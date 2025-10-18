package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Game;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface GameRepository extends JpaRepository<Game, Long> {

    /**
     * Find game by name
     */
    Optional<Game> findByName(String name);
}
