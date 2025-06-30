package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    Optional<User> findByEmail(String email);
    
    Boolean existsByEmail(String email);
    
    List<User> findByRole(User.UserRole role);
    
    List<User> findByStatus(User.UserStatus status);
    
    @Query("SELECT u FROM User u WHERE u.role = :role AND u.status = :status")
    List<User> findByRoleAndStatus(@Param("role") User.UserRole role, @Param("status") User.UserStatus status);
    
    @Query("SELECT u FROM User u WHERE LOWER(u.FName) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<User> findByFNameContainingIgnoreCase(@Param("name") String name);
}