<?php

class Database {
    public static mysqli $static_conn;
    public mysqli $conn;

    public function connect() {
        if (!isset(Database::$static_conn)) {
            self::$static_conn = new mysqli("172.17.0.1", "root", "", "autocars");
            if (self::$static_conn->connect_errno) {
                throw new MysqlException("Error connecting to db");
            }
        }
        $this->conn = Database::$static_conn;
    }
    public function close() {
        if (isset(self::$static_conn)) { // Close connection if is set
            self::$static_conn->close();
        }
    }
    
    public function __construct() {
        
    }

    public function query(string $query_str, string $types = '', ...$values) {
        if (!isset($this->conn)) {
            $this->connect();
        }
        if (count($values) == 0 || $types == '') {
            $query = $this->conn->query($query_str);
            $result = (object) [];
            if ($query === false) {
                throw new MysqlException('Mysqli error: ' . mysqli_error($this->conn));
            } else {
                if (isset($query->insert_id)) {
                    $result->insert_id = $query->insert_id;
                }
                $result->query = $query;
                if ($result->query) {
                    return $result->query->fetch_all(MYSQLI_ASSOC);
                } else {
                    return 0;
                }
            }
        } else {
            $stmt = $this->conn->prepare($query_str);
            if (!$stmt) {
                throw new MysqlException('Error invalid prepared query ' . $query_str);
            }
            $stmt->bind_param($types, ...$values);
            if (!$stmt->execute()) {
                if ($stmt->sqlstate == 45000) {
                    throw new BadReqException($stmt->error);
                } else { 
                    throw new MysqlException('Error executing query: ' . $stmt->error);
                }
            }
            $result = (object) [];
            $result->insert_id = $stmt->insert_id;
            $result->query = $stmt->get_result();
            if ($result === false) {
                throw new MysqlException('Mysqli error: ' . mysqli_error($this->conn));
            }
            $stmt->close();
            if ($result->query) {
                return $result->query->fetch_all(MYSQLI_ASSOC);
            } else {
                return 0;
            }
        }
        
    }
}

?>
