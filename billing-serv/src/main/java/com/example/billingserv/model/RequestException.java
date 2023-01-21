package com.example.billingserv.model;


public class RequestException {
    private Integer answerId;
    private String answerMessage;
    private String answerComment;

    public RequestException(Integer answerId, String answerMessage, String answerComment) {
        this.answerId = answerId;
        this.answerMessage = answerMessage;
        this.answerComment = answerComment;
    }

    public RequestException() {
    }

    public Integer getAnswerId() {
        return answerId;
    }

    public void setAnswerId(Integer answerId) {
        this.answerId = answerId;
    }

    public String getAnswerMessage() {
        return answerMessage;
    }

    public void setAnswerMessage(String answerMessage) {
        this.answerMessage = answerMessage;
    }

    public String getAnswerComment() {
        return answerComment;
    }

    public void setAnswerComment(String answerComment) {
        this.answerComment = answerComment;
    }
}
