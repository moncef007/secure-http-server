# Secure HTTP Server API Documentation

## Overview

The Secure HTTP Server provides a RESTful API for file management operations with HTTP Basic Authentication.

## Authentication

All endpoints require HTTP Basic Authentication:

```http
Authorization: Basic <base64(username:password)>
```

## Base URL

```
http://localhost:9000
```

## Endpoints

### GET /

List all files and directories in the root directory.

**Response:**
- `200 OK`: HTML directory listing
- `401 Unauthorized`: Authentication required

### GET /{path}

Retrieve a file or directory listing.

**Parameters:**
- `path`: File or directory path (URL encoded)

**Response:**
- `200 OK`: File content or HTML directory listing
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Access denied (path traversal attempt)
- `404 Not Found`: File or directory not found

**Example:**
```bash
curl -u username:password http://localhost:9000/documents/report.pdf
```

### PUT /{path}

Create or update a file.

**Parameters:**
- `path`: File path (URL encoded)

**Request Body:**
- Raw file content

**Response:**
- `200 OK`: File created/updated successfully
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Access denied
- `500 Internal Server Error`: Write error

**Example:**
```bash
curl -u username:password -X PUT \
  --data-binary @local-file.txt \
  http://localhost:9000/remote-file.txt
```

### POST /{path}

Append data to an existing file or create if it doesn't exist.

**Parameters:**
- `path`: File path (URL encoded)

**Request Body:**
- Data to append

**Response:**
- `201 Created`: Data appended successfully
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Access denied
- `500 Internal Server Error`: Write error

**Example:**
```bash
curl -u username:password -X POST \
  --data "Additional content" \
  http://localhost:9000/log.txt
```

### DELETE /{path}

Delete a file.

**Parameters:**
- `path`: File path (URL encoded)

**Response:**
- `200 OK`: File deleted successfully
- `401 Unauthorized`: Authentication required
- `403 Forbidden`: Access denied
- `404 Not Found`: Resource not found
- `500 Internal Server Error`: Server error

## Rate Limiting

Currently, the server does not implement rate limiting. For production use, consider implementing:
- Request rate limiting per IP
- Authentication attempt limiting
- File upload size restrictions

## File Upload Limits

No hard limits are enforced by default. Large file uploads may be limited by:
- Available disk space
- System memory
- Network timeouts

## Examples

### Upload a file
```bash
curl -u admin:admin123 -X PUT \
  --data-binary @document.pdf \
  http://localhost:9000/uploads/document.pdf
```

### Download a file
```bash
curl -u admin:admin123 \
  http://localhost:9000/uploads/document.pdf \
  -o document.pdf
```

### List directory contents
```bash
curl -u admin:admin123 http://localhost:9000/uploads/
```

### Append to log file
```bash
echo "Log entry" | curl -u admin:admin123 -X POST \
  --data-binary @- \
  http://localhost:9000/server.log
```

### Delete a file
```bash
curl -u admin:admin123 -X DELETE \
  http://localhost:9000/temp/old-file.txt
```

## Best Practices

1. **Change Default Password**: Always change the default admin password immediately after installation
2. **Use HTTPS**: For production, use a reverse proxy with SSL/TLS
3. **Restrict Access**: Bind to localhost only unless external access is required
4. **Regular Backups**: Implement regular backups of served files
5. **Monitor Logs**: Regularly review server logs for suspicious activity
6. **User Management**: Regularly audit user accounts and remove unnecessary ones File not found
- `500 Internal Server Error`: Delete error

**Example:**
```bash
curl -u username:password -X DELETE \
  http://localhost:9000/old-file.txt
```

## User Management API

User management is performed via command-line interface:

### List Users
```bash
secure-http-server --list-users
```

### Add User
```bash
secure-http-server --add-user <username> <password> <role>
```

### Remove User
```bash
secure-http-server --remove-user <username>
```

### Interactive Management
```bash
secure-http-server --manage-users
```

## Security Features

### Path Traversal Prevention

The server prevents directory traversal attacks by:
- Normalizing all paths
- Ensuring requested paths are within the server's root directory
- Rejecting requests containing `..` sequences

### Password Security

- Passwords are hashed using SHA-256
- Passwords are never stored in plain text
- Default admin password should be changed immediately

### Authentication

- HTTP Basic Authentication required for all operations
- No session management - each request must include credentials
- Failed authentication returns 401 Unauthorized

## Error Responses

All error responses include a plain text message describing the error.

### Common Status Codes

- `200 OK`: Request successful
- `201 Created`: Resource created/modified
- `400 Bad Request`: Invalid request
- `401 Unauthorized`: Authentication required or failed
- `403 Forbidden`: Access denied
- `404 Not Found`: Not found