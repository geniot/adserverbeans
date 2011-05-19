package com.adserversoft.flexfuse.server.service;

/**
 * Author: Vitaly Sazanovich
 * Vitaly.Sazanovich@gmail.com
 */
public class GenSalt {
    public static void main(String[] args) {
        new GenSalt().run(args);
    }

    public void run(String[] args) {
        try {

            String pwd = "";
            if (args.length > 0) pwd = args[0];
            String pw_hash = BCrypt.hashpw(pwd, BCrypt.gensalt());
            System.out.println(pw_hash);
        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }
}