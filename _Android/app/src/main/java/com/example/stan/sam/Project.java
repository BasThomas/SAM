package com.example.stan.sam;

/**
 * Created by Stan on 18-5-2015.
 */
public class Project {
    private String id;
    private String naam;
    private String route;
    private boolean checkedIn;
    private boolean afgerond;

    public Project(String id, String naam, String route, boolean checkedIn, boolean afgerond){
        super();
        this.id = id;
        this.naam = naam;
        this.route = route;
        this.checkedIn = checkedIn;
        this.afgerond = afgerond;
    }
    public String getId(){
        return id;
    }
    public String getNaam(){
        return naam;
    }
    public String getRoute(){
        return route;
    }
    public boolean isAfgerond(){
        return afgerond;
    }
    public boolean isCheckedIn(){
        return checkedIn;
    }
}
