package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.Game;
import Memora.DimensiaCareApplication.repository.GameRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/games")
@CrossOrigin(origins = "*")
public class GameController {

    @Autowired
    private GameRepository gameRepository;

    // Get all games
    @GetMapping
    public ResponseEntity<List<Game>> getAllGames() {
        try {
            System.out.println("GameController - Getting all games");
            List<Game> games = gameRepository.findAll();
            System.out.println("GameController - Found " + games.size() + " games");

            // Log each game for debugging
            for (Game game : games) {
                System.out.println("Game: ID=" + game.getGameId() +
                        ", Name=" + game.getName() +
                        ", Description=" + game.getDescription());
            }

            return ResponseEntity.ok(games);
        } catch (Exception e) {
            System.err.println("GameController - Error getting games: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500).build();
        }
    }

    // Get game by ID
    @GetMapping("/{id}")
    public ResponseEntity<Game> getGameById(@PathVariable Long id) {
        try {
            Optional<Game> game = gameRepository.findById(id);
            if (game.isPresent()) {
                return ResponseEntity.ok(game.get());
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).build();
        }
    }

    // Create new game
    @PostMapping
    public ResponseEntity<Game> createGame(@RequestBody Game game) {
        try {
            Game savedGame = gameRepository.save(game);
            return ResponseEntity.ok(savedGame);
        } catch (Exception e) {
            return ResponseEntity.status(500).build();
        }
    }

    // Update game
    @PutMapping("/{id}")
    public ResponseEntity<Game> updateGame(@PathVariable Long id, @RequestBody Game gameDetails) {
        try {
            Optional<Game> game = gameRepository.findById(id);
            if (game.isPresent()) {
                Game existingGame = game.get();
                existingGame.setName(gameDetails.getName());
                existingGame.setDescription(gameDetails.getDescription());
                Game updatedGame = gameRepository.save(existingGame);
                return ResponseEntity.ok(updatedGame);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).build();
        }
    }

    // Delete game
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteGame(@PathVariable Long id) {
        try {
            if (gameRepository.existsById(id)) {
                gameRepository.deleteById(id);
                return ResponseEntity.ok().build();
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).build();
        }
    }
}
