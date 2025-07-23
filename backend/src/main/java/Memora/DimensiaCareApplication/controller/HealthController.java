package Memora.DimensiaCareApplication.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class HealthController {

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "Memora Dimensia Care API");
        response.put("timestamp", System.currentTimeMillis());
        response.put("serverIp", getServerIpAddress());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/server-info")
    public ResponseEntity<Map<String, Object>> getServerInfo() {
        Map<String, Object> response = new HashMap<>();
        String serverIp = getServerIpAddress();

        response.put("serverIp", serverIp);
        response.put("port", "8080");
        response.put("baseUrl", "http://" + serverIp + ":8080");
        response.put("timestamp", System.currentTimeMillis());
        response.put("hostname", getHostname());

        return ResponseEntity.ok(response);
    }

    private String getServerIpAddress() {
        try {
            // Get all network interfaces
            for (NetworkInterface networkInterface : Collections.list(NetworkInterface.getNetworkInterfaces())) {
                // Skip loopback and inactive interfaces
                if (networkInterface.isLoopback() || !networkInterface.isUp()) {
                    continue;
                }

                // Get all IP addresses for this interface
                for (InetAddress address : Collections.list(networkInterface.getInetAddresses())) {
                    // Skip IPv6 and loopback addresses
                    if (!address.isLoopbackAddress() && address.getAddress().length == 4) {
                        String ip = address.getHostAddress();
                        // Prefer local network IPs (192.168.x.x, 10.x.x.x, 172.16-31.x.x)
                        if (ip.startsWith("192.168.") || ip.startsWith("10.") ||
                                (ip.startsWith("172.") && isPrivateIP172(ip))) {
                            return ip;
                        }
                    }
                }
            }

            // Fallback to localhost IP
            return InetAddress.getLocalHost().getHostAddress();
        } catch (Exception e) {
            return "localhost";
        }
    }

    private boolean isPrivateIP172(String ip) {
        String[] parts = ip.split("\\.");
        if (parts.length == 4 && parts[0].equals("172")) {
            try {
                int secondOctet = Integer.parseInt(parts[1]);
                return secondOctet >= 16 && secondOctet <= 31;
            } catch (NumberFormatException e) {
                return false;
            }
        }
        return false;
    }

    private String getHostname() {
        try {
            return InetAddress.getLocalHost().getHostName();
        } catch (Exception e) {
            return "unknown";
        }
    }
}
