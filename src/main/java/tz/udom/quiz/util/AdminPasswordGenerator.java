package tz.udom.quiz.util;

import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class AdminPasswordGenerator {

    private static final int ITERATIONS = 65536;
    private static final int SALT_LENGTH = 16;
    private static final int KEY_LENGTH = 256;

    public static void main(String[] args) throws Exception {

        String password = "admin123";

        SecureRandom secureRandom =
                new SecureRandom();

        byte[] salt =
                new byte[SALT_LENGTH];

        secureRandom.nextBytes(salt);

        PBEKeySpec spec =
                new PBEKeySpec(
                        password.toCharArray(),
                        salt,
                        ITERATIONS,
                        KEY_LENGTH
                );

        SecretKeyFactory factory =
                SecretKeyFactory.getInstance(
                        "PBKDF2WithHmacSHA256"
                );

        byte[] hash =
                factory.generateSecret(spec)
                        .getEncoded();

        String passwordHash =
                ITERATIONS
                + ":"
                + Base64.getEncoder()
                        .encodeToString(salt)
                + ":"
                + Base64.getEncoder()
                        .encodeToString(hash);

        System.out.println();
        System.out.println("Password Hash:");
        System.out.println(passwordHash);
        System.out.println();
    }
}