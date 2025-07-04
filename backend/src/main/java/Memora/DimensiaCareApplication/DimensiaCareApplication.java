package Memora.DimensiaCareApplication;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaRepositories("Memora.DimensiaCareApplication.repository")
@EnableJpaAuditing
public class DimensiaCareApplication {

	public static void main(String[] args) {
		SpringApplication.run(DimensiaCareApplication.class, args);
	}

}
