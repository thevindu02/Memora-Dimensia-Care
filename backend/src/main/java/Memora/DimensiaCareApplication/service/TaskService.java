package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.CareActivity;
import Memora.DimensiaCareApplication.model.CareActivityStatus;
import Memora.DimensiaCareApplication.model.Game;
import Memora.DimensiaCareApplication.model.Schedule;
import Memora.DimensiaCareApplication.model.Task;
import Memora.DimensiaCareApplication.repository.CareActivityRepository;
import Memora.DimensiaCareApplication.repository.GameRepository;
import Memora.DimensiaCareApplication.repository.ScheduleRepository;
import Memora.DimensiaCareApplication.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional
public class TaskService {
    /**
     * Edit game task (game name, time, description)
     */
    public Map<String, Object> editGameTask(Long taskId, String gameName, String timeString, String description) {
        try {
            Task task = taskRepository.findById(taskId.intValue())
                    .orElseThrow(() -> new RuntimeException("Task not found with ID: " + taskId));

            // Update game
            Game game = gameRepository.findByName(gameName)
                    .orElseThrow(() -> new RuntimeException("Game not found with name: " + gameName));
            task.setGame(game);

            // Update time in CareActivity
            CareActivity careActivity = task.getCareActivity();
            careActivity.setTime(LocalTime.parse(timeString));

            // Optionally update description if CareActivity has a description field
            // If not, you may want to add it to the Task or CareActivity model
            // Example: careActivity.setDescription(description);
            // If not present, skip this line

            careActivityRepository.save(careActivity);
            taskRepository.save(task);

            Map<String, Object> response = convertToResponse(task);
            response.put("message", "Game task updated successfully");
            return response;
        } catch (Exception e) {
            throw new RuntimeException("Failed to edit game task: " + e.getMessage(), e);
        }
    }

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private CareActivityRepository careActivityRepository;

    @Autowired
    private GameRepository gameRepository;

    @Autowired
    private ScheduleRepository scheduleRepository;

    /**
     * Create a new task - updates both careactivity and task tables
     */
    public Map<String, Object> createTask(Integer scheduleId, String gameName, String timeString) {
        try {
            System.out.println("TaskService - Creating task: scheduleId=" + scheduleId +
                    ", gameName=" + gameName + ", time=" + timeString);

            // Find the schedule
            Schedule schedule = scheduleRepository.findById(scheduleId.longValue())
                    .orElseThrow(() -> new RuntimeException("Schedule not found with ID: " + scheduleId));

            // Find the game by name
            Game game = gameRepository.findByName(gameName)
                    .orElseThrow(() -> new RuntimeException("Game not found with name: " + gameName));

            // Parse time string to LocalTime
            LocalTime time = LocalTime.parse(timeString);

            // Create CareActivity first
            CareActivity careActivity = new CareActivity();
            careActivity.setSchedule(schedule);
            careActivity.setTime(time);
            careActivity.setStatus(CareActivityStatus.PENDING);
            careActivity.setSkipReason(null);

            // Save care activity
            CareActivity savedCareActivity = careActivityRepository.save(careActivity);
            System.out.println("TaskService - CareActivity created with ID: " + savedCareActivity.getCareActivityId());

            // Create Task
            Task task = new Task();
            task.setCareActivity(savedCareActivity);
            task.setGame(game);

            // Save task
            Task savedTask = taskRepository.save(task);
            System.out.println("TaskService - Task created with ID: " + savedTask.getTaskId());

            // Create response
            Map<String, Object> response = new HashMap<>();
            response.put("taskId", savedTask.getTaskId());
            response.put("careActivityId", savedCareActivity.getCareActivityId());
            response.put("scheduleId", scheduleId);
            response.put("gameName", game.getName());
            response.put("gameId", game.getGameId());
            response.put("time", timeString);
            response.put("status", savedCareActivity.getStatus().toString());
            response.put("message", "Task created successfully");

            System.out.println("TaskService - Task created successfully: " + response);
            return response;

        } catch (Exception e) {
            System.err.println("TaskService - Error creating task: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to create task: " + e.getMessage(), e);
        }
    }

    /**
     * Get all tasks by schedule ID
     */
    public List<Map<String, Object>> getTasksByScheduleId(Integer scheduleId) {
        try {
            System.out.println("TaskService - Getting tasks for schedule ID: " + scheduleId);

            List<Task> tasks = taskRepository.findByScheduleId(scheduleId);
            System.out.println("TaskService - Found " + tasks.size() + " tasks");

            return tasks.stream()
                    .map(this::convertToResponse)
                    .collect(Collectors.toList());

        } catch (Exception e) {
            System.err.println("TaskService - Error getting tasks: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get tasks: " + e.getMessage(), e);
        }
    }

    /**
     * Update task status (updates CareActivity status)
     */
    public Map<String, Object> updateTaskStatus(Long taskId, String status) {
        try {
            System.out.println("TaskService - Updating task " + taskId + " status to: " + status);

            Task task = taskRepository.findById(taskId.intValue())
                    .orElseThrow(() -> new RuntimeException("Task not found with ID: " + taskId));

            // Update the CareActivity status
            CareActivity careActivity = task.getCareActivity();
            careActivity.setStatus(CareActivityStatus.valueOf(status.toUpperCase()));
            careActivityRepository.save(careActivity);

            Map<String, Object> response = convertToResponse(task);
            System.out.println("TaskService - Task updated successfully: " + response);
            return response;

        } catch (Exception e) {
            System.err.println("TaskService - Error updating task: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to update task: " + e.getMessage(), e);
        }
    }

    /**
     * Delete a task
     */
    public void deleteTask(Long taskId) {
        try {
            System.out.println("TaskService - Deleting task: " + taskId);

            Task task = taskRepository.findById(taskId.intValue())
                    .orElseThrow(() -> new RuntimeException("Task not found with ID: " + taskId));

            taskRepository.delete(task);
            System.out.println("TaskService - Task deleted successfully");

        } catch (Exception e) {
            System.err.println("TaskService - Error deleting task: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to delete task: " + e.getMessage(), e);
        }
    }

    /**
     * Convert Task entity to response map
     */
    private Map<String, Object> convertToResponse(Task task) {
        CareActivity careActivity = task.getCareActivity();
        Game game = task.getGame();

        Map<String, Object> response = new HashMap<>();
        response.put("taskId", task.getTaskId());
        response.put("careActivityId", careActivity.getCareActivityId());
        response.put("scheduleId", careActivity.getSchedule().getScheduleId());
        response.put("gameName", game.getName());
        response.put("gameId", game.getGameId());
        response.put("time", careActivity.getTime().toString());
        response.put("status", careActivity.getStatus().toString());

        return response;
    }
}
