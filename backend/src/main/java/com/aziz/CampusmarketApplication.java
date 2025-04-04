package com.aziz;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CampusmarketApplication {

	public static void main(String[] args) {

		// Load .env file
		Dotenv dotenv = Dotenv.load();
		System.setProperty("DB_URL", dotenv.get("DB_URL"));
		System.setProperty("DB_USER", dotenv.get("DB_USER"));
		System.setProperty("DB_PASS", dotenv.get("DB_PASS"));
		System.setProperty("GMAIL_MAIL", dotenv.get("GMAIL_MAIL"));
		System.setProperty("GMAIL_PASSWORD", dotenv.get("GMAIL_PASSWORD"));

		SpringApplication.run(CampusmarketApplication.class, args);
	}

}
