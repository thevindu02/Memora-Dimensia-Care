package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/tasks")
@CrossOrigin(origins = "*")
public class TaskController {

    @Autowired
    private TaskService taskService;

    /**
     * Create a new task
     */
    @PostMapping
    public ResponseEntity<?> createTask(@RequestBody Map<String, Object> request) {
        try {
            System.out.println("TaskController - Creating task with request: " + request);

            // Extract parameters from request
            Integer scheduleId = (Integer) request.get("scheduleId");
            String gameName = (String) request.get("gameName");
            String time = (String) request.get("time");

            if (scheduleId == null || gameName == null || time == null) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Missing required fields: scheduleId, gameName, time"));
            }

            Object result = taskService.createTask(scheduleId, gameName, time);
            System.out.println("TaskController - Task created successfully");
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            System.err.println("TaskController - Error creating task: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "Failed to create task: " + e.getMessage()));
        }
    }

    /**
     * Get all tasks by schedule ID
     */
    @GetMapping("/schedule/{scheduleId}")
    public ResponseEntity<?> getTasksByScheduleId(@PathVariable Integer scheduleId) {
        try {
            System.out.println("TaskController - Getting tasks for schedule ID: " + scheduleId);
            Object result = taskService.getTasksByScheduleId(scheduleId);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            System.err.println("TaskController - Error getting tasks: " + e.getMessage());
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "Failed to get tasks: " + e.getMessage()));
        }
    }

    /**
     * Update task status
     */
    @PutMapping("/{taskId}/status")
    public ResponseEntity<?> updateTaskStatus(@PathVariable Long taskId, @RequestBody Map<String, String> request) {
        try {
            System.out.println("TaskController - Updating task " + taskId + " status");
            String status = request.get("status");
            if (status == null) {
                return ResponseEntity.badRequest()
                        .body(Map.of("error", "Status is required"));
            }

            Object result = taskService.updateTaskStatus(taskId, status);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            System.err.println("TaskController - Error updating task: " + e.getMessage());
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "Failed to update task: " + e.getMessage()));
        }
    }

    /**
     * Delete a task
     */
    @DeleteMapping("/{taskId}")
    public ResponseEntity<?> deleteTask(@PathVariable Long taskId) {
        try {
            System.out.println("TaskController - Deleting task: " + taskId);
            taskService.deleteTask(taskId);
            return ResponseEntity.ok(Map.of("message", "Task deleted successfully"));
        } catch (Exception e) {
            System.err.println("TaskController - Error deleting task: " + e.getMessage());
            return ResponseEntity.internalServerError()
                    .body(Map.of("error", "Failed to delete task: " + e.getMessage()));
        }
    }
}