package com.trubochisty.truboserver;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class TruboserverApplication {

	public static void main(String[] args) {
		System.out.println("Truboserver Application Started");
		SpringApplication.run(TruboserverApplication.class, args);
	}

}
