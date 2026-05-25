package com.curious.drifiting_bottle.service;

import com.curious.drifiting_bottle.model.TokenPair;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.SignatureException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.util.Date;
import java.util.Map;

@Service
@Slf4j
public class JwtService {

    @Value("${app.jwt.secret}")
    private String jwtSecret;

    @Value("${app.jwt.expiration}")
    private long jwtExpirationMs;

    @Value("${app.jwt.refresh-expiration}")
    private long refreshExpirationMs;

    private static final String TOKEN_PREFIX = "Bearer ";

    public TokenPair generateTokenPair(Authentication authentication) {
        String accessToken = generateAccessToken(authentication);
        String refreshToken = generateRefreshToken(authentication);
        return new TokenPair(accessToken, refreshToken);
    }

    public String generateAccessToken(Authentication authentication) {

        return buildToken(
                authentication,
                jwtExpirationMs,
                null
        );
    }

    public String generateRefreshToken(Authentication authentication) {

        return buildToken(
                authentication,
                refreshExpirationMs,
                Map.of("token", "refresh")
        );
    }

    private String buildToken(
            Authentication authentication,
            long expiration,
            Map<String, Object> claims
    ) {

        UserDetails userPrincipal =
                (UserDetails) authentication.getPrincipal();

        Date now = new Date();

        Date expiryDate =
                new Date(now.getTime() + expiration);

        var builder = Jwts.builder()
                .setSubject(userPrincipal.getUsername())
                .setIssuedAt(now)
                .setExpiration(expiryDate);

        if (claims != null && !claims.isEmpty()) {
            builder.addClaims(claims);
        }

        return builder
                .signWith(getSignInKey())
                .compact();
    }

    public boolean isValidToken(
            String token,
            UserDetails userDetails
    ) {

        try {

            final String username =
                    extractUsernameFromToken(token);

            return username.equals(userDetails.getUsername())
                    && !isTokenExpired(token);

        } catch (SignatureException e) {

            log.error("Invalid JWT signature: {}", e.getMessage());

        } catch (MalformedJwtException e) {

            log.error("Invalid JWT token: {}", e.getMessage());

        } catch (ExpiredJwtException e) {

            log.error("JWT token expired: {}", e.getMessage());

        } catch (UnsupportedJwtException e) {

            log.error("JWT token unsupported: {}", e.getMessage());

        } catch (IllegalArgumentException e) {

            log.error("JWT claims string is empty: {}", e.getMessage());
        }

        return false;
    }

    public boolean isRefreshToken(String token) {

        Claims claims = Jwts.parserBuilder()
                .setSigningKey(getSignInKey())
                .build()
                .parseClaimsJws(token)
                .getBody();

        return "refresh".equals(claims.get("token"));
    }

    public String extractUsernameFromToken(String token) {

        return extractAllClaims(token)
                .getSubject();
    }



    private boolean isTokenExpired(String token) {

        return extractAllClaims(token)
                .getExpiration()
                .before(new Date());
    }

    private Claims extractAllClaims(String token) {

        return Jwts.parserBuilder()
                .setSigningKey(getSignInKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    private Key getSignInKey() {

        byte[] keyBytes =
                Decoders.BASE64.decode(jwtSecret);

        return Keys.hmacShaKeyFor(keyBytes);
    }

    public String extractTokenFromHeader(String header) {

        if (header != null &&
                header.startsWith(TOKEN_PREFIX)) {

            return header.substring(TOKEN_PREFIX.length());
        }

        return null;
    }


}