package com.sp.app.domain.dto;

import java.util.List;

public class AiResumeRequest {
    private List<String> skills;
    private List<String> strengths;
    private List<String> goals;

    public List<String> getSkills() { return skills; }
    public void setSkills(List<String> skills) { this.skills = skills; }
    public List<String> getStrengths() { return strengths; }
    public void setStrengths(List<String> strengths) { this.strengths = strengths; }
    public List<String> getGoals() { return goals; }
    public void setGoals(List<String> goals) { this.goals = goals; }
}