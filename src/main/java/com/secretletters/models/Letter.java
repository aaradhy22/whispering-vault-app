package com.secretletters.models;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Letter {
    private int id; // ADD THIS
    private String content;
    private Timestamp createdAt;
    private Timestamp updatedAt; // ADD THIS

    public Letter(int id, String content, Timestamp createdAt, Timestamp updatedAt) { // UPDATE THIS
        this.id = id;
        this.content = content;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // ADD GETTERS FOR THE NEW FIELDS
    public int getId() {
        return id;
    }

    public String getContent() {
        return content;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    // UPDATE getFormattedTimestamp TO SHOW "Edited" if applicable
    public String getFormattedTimestamp() {
        // Check if updatedAt is significantly later than createdAt
        if (updatedAt != null && createdAt != null && (updatedAt.getTime() - createdAt.getTime() > 10000)) { // 10s threshold
            return "Edited " + new SimpleDateFormat("MMMM dd, yyyy 'at' hh:mm a").format(updatedAt);
        }
        if (createdAt != null) {
            return new SimpleDateFormat("MMMM dd, yyyy 'at' hh:mm a").format(createdAt);
        }
        return "A moment ago";
    }
}