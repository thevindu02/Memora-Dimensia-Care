#!/bin/bash

echo "=== Server IP Address Discovery Tool ==="
echo ""

# Function to get local IP address
get_local_ip() {
    local ip=""
    
    # Try different methods to get the IP
    if command -v ip >/dev/null 2>&1; then
        # Linux with ip command
        ip=$(ip route get 8.8.8.8 2>/dev/null | grep -oP 'src \K\S+' | head -1)
    fi
    
    if [ -z "$ip" ] && command -v ifconfig >/dev/null 2>&1; then
        # macOS/Linux with ifconfig
        ip=$(ifconfig | grep -E "inet.*broadcast" | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
    fi
    
    if [ -z "$ip" ]; then
        # Windows WSL or fallback
        ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    fi
    
    echo "$ip"
}

# Get the IP address
SERVER_IP=$(get_local_ip)

if [ -n "$SERVER_IP" ]; then
    echo "✅ Server IP Address Found: $SERVER_IP"
    echo ""
    echo "📱 Update your mobile app with this URL:"
    echo "   http://$SERVER_IP:8080"
    echo ""
    echo "🔧 You can update ApiConstants.dart with:"
    echo "   static const String baseUrl = \"http://$SERVER_IP:8080\";"
    echo ""
    echo "🌐 Network Information:"
    echo "   Hostname: $(hostname)"
    echo "   IP Address: $SERVER_IP"
    echo "   Port: 8080"
    echo "   Full API URL: http://$SERVER_IP:8080/api"
    echo ""
    echo "🔗 Test URLs:"
    echo "   Health Check: http://$SERVER_IP:8080/api/health"
    echo "   Server Info: http://$SERVER_IP:8080/api/server-info"
else
    echo "❌ Could not determine server IP address"
    echo ""
    echo "📋 Manual methods to find your IP:"
    echo "   • Windows: ipconfig | findstr IPv4"
    echo "   • macOS: ifconfig en0 | grep inet"
    echo "   • Linux: ip addr show | grep inet"
    echo ""
fi

echo ""
echo "💡 Tips:"
echo "   • Make sure your phone and computer are on the same WiFi network"
echo "   • If using a different port, replace 8080 with your port number"
echo "   • The IP address might change if you connect to a different network"
