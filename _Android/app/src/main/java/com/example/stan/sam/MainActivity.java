package com.example.stan.sam;

import android.app.ActionBar;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.media.Image;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.StrictMode;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.internal.view.menu.MenuView;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ArrayAdapter;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.Switch;
import android.widget.TextView;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.net.URI;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import android.os.Handler;


public class MainActivity extends Activity implements
        SwipeRefreshLayout.OnRefreshListener {
    private List<Project> projects = new ArrayList<Project>();
    private int[] colors = new int[] { 0xFFFFFFFF, 0xfff0f0f0 };
    private String tijd = "0";
    private int currentposition;
    private boolean noConScreen = false;
    SwipeRefreshLayout swipeLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        if (android.os.Build.VERSION.SDK_INT > 9) {
            StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
            StrictMode.setThreadPolicy(policy);
        }
        getProjects();
        insertListView();
        Sync sync = new Sync(call,60*1000);
        swipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipe_container);
        swipeLayout.setOnRefreshListener(this);
        swipeLayout.setColorScheme(R.color.apptheme_color);
    }
    final private Runnable call = new Runnable() {
        public void run() {
            //This is where my sync code will be, but for testing purposes I only have a Log statement
            tijd = Integer.toString(Integer.valueOf(tijd) + 60);
            ListView list = (ListView) findViewById(R.id.list);
            View v = (View) list.getChildAt(currentposition);
            TextView tijdText = (TextView) v.findViewById(R.id.timeText);
            int hr = Integer.valueOf(tijd)/3600;
            int rem = Integer.valueOf(tijd)%3600;
            int mn = rem/60;
            String hrStr = (hr==0 ? "" : hr + " uur  ");
            String mnStr = (mn==1 ? mn + " minuut" : hr + " minuten");
            tijdText.setText(hrStr + mnStr);
            handler.postDelayed(call,60*1000);
        }
    };
    public final Handler handler = new Handler();

    @Override
    public void onRefresh() {
        new Handler().postDelayed(new Runnable() {
            @Override public void run() {
                projects.clear();
                getProjects();
                insertListView();
                swipeLayout.setRefreshing(false);
            }
        }, 100);
    }

    public class Sync {


        Runnable task;

        public Sync(Runnable task, long time) {
            this.task = task;
            handler.removeCallbacks(task);
            handler.postDelayed(task, time);
        }
    }

    private boolean isNetworkAvailable() {
        ConnectivityManager connectivityManager
                = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
        return activeNetworkInfo != null && activeNetworkInfo.isConnected();
    }

    private void noConnection(){
        if(noConScreen==false) {
            noConScreen = true;
            AlertDialog alertDialog = new AlertDialog.Builder(this).create();
            alertDialog.setTitle("Error!");
            alertDialog.setMessage("Geen internet verbinding mogelijk!");
            alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int which) {
                    noConScreen = false;
                }
            });
            alertDialog.setInverseBackgroundForced(true);
            Drawable draw = this.getResources().getDrawable(android.R.drawable.stat_sys_warning);
            draw.setColorFilter(0xff222222, PorterDuff.Mode.MULTIPLY);
            alertDialog.setIcon(draw);
            alertDialog.show();
        }
    }

    protected void onResume() {
        super.onResume();
        projects.clear();
        getProjects();
        insertListView();
    }

    public void getProjects() {
        if(isNetworkAvailable()==true){
            JSONParser jParser = new JSONParser();
            JSONObject json = jParser.getJSONFromUrl("http://i300486.iris.fhict.nl/SAM/userinfo.php?key=SAMjson&pcn=300486");
            JSONArray allProjects = null;
            try {
                allProjects = (JSONArray) json.get("projects");
                for(int i=0;i<allProjects.length();i++){
                    JSONObject object = (JSONObject) allProjects.getJSONObject(i);
                    String id = (String) object.get("id");
                    String naam = (String) object.get("name");
                    String route = (String) object.get("route");
                    boolean checkedIn = (boolean) object.get("checkedin");
                    String afgerond = (String) object.get("enddate");
                    boolean af = false;
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    final Calendar c = Calendar.getInstance();
                    try {
                        Date parsedDate = dateFormat.parse(afgerond);
                        c.setTime(parsedDate);
                        if(c.get(Calendar.YEAR) > 2000){
                            af = true;
                        }
                    } catch (ParseException e) {
                        e.printStackTrace();
                    }
                    projects.add(new Project(id, naam, route, checkedIn, af));
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        } else {
            noConnection();
        }
    }

    private void insertListView(){
        ArrayAdapter<Project> adapter = new MyListAdapter();
        ListView mList = (ListView) findViewById(R.id.list);
        int index = mList.getFirstVisiblePosition();
        View v = mList.getChildAt(0);
        int top = (v == null) ? 0 : (v.getTop() - mList.getPaddingTop());
        ListView list = (ListView) findViewById(R.id.list);
        list.setAdapter(adapter);
        mList.setSelectionFromTop(index, top);
    }

    private class MyListAdapter extends ArrayAdapter<Project>{
        public MyListAdapter() {
            super(MainActivity.this, R.layout.project_itemview, projects);
        }

        @Override
        public View getView(final int position, View convertView, ViewGroup parent){
            View itemView = convertView;
            if(itemView==null){
                itemView = getLayoutInflater().inflate(R.layout.project_itemview, parent, false);
            }

            Project currentProject = projects.get(position);
            String currentString = currentProject.getNaam();

            TextView naamView = (TextView)itemView.findViewById(R.id.naamView);
            TextView routeView = (TextView)itemView.findViewById(R.id.routeView);

            int colorPos = position % colors.length;
            itemView.setBackgroundColor(colors[colorPos]);

            naamView.setText(currentString);
            routeView.setText(currentProject.getRoute());
            Switch projectSwitch = (Switch)itemView.findViewById(R.id.checkSwitch);
            TextView tijdText = (TextView) itemView.findViewById(R.id.timeText);
            if(currentProject.isCheckedIn()==true){
                projectSwitch.setChecked(true);
                itemView.setBackgroundColor(0x7733b5e5);
                if(isNetworkAvailable()==true) {
                    tijdText.setVisibility(View.VISIBLE);
                    currentposition = position;
                    JSONParser jParser = new JSONParser();
                    String id = currentProject.getId();
                    JSONObject json = jParser.getJSONFromUrl("http://i300486.iris.fhict.nl/SAM/checkedinfor.php?key=SAMjson&pcn=300486&id=" + id);
                    try {
                        tijd = (String) json.get("timelogged");
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    int hr = Integer.valueOf(tijd) / 3600;
                    int rem = Integer.valueOf(tijd) % 3600;
                    int mn = rem / 60;
                    String hrStr = (hr == 0 ? "" : hr + " uur  ");
                    String mnStr = (mn > 1 ? mn + " minuut" : hr + " minuten");
                    tijdText.setText(hrStr + mnStr);
                } else {
                    noConnection();
                }
            } else {
                projectSwitch.setChecked(false);
                tijdText.setVisibility(View.GONE);
            }
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent intent = new Intent("prav.projectActivity");
                    TextView idtext = (TextView) v.findViewById(R.id.idView);
                    intent.putExtra("id", idtext.getText().toString());
                    startActivity(intent);
                }
            });

            projectSwitch.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if(isNetworkAvailable()==true) {
                        View toggledView = (View) v.getParent();
                        TextView idview = (TextView) toggledView.findViewById(R.id.idView);
                        String id = idview.getText().toString();
                        toggledView.setBackgroundColor(0x773399aa);
                        StringBuilder response = new StringBuilder();
                        try {
                            HttpGet get = new HttpGet();
                            get.setURI(URI.create("http://i300486.iris.fhict.nl/SAM/check.php?key=SAMjson&pcn=300486&id=" + id));
                            DefaultHttpClient httpClient = new DefaultHttpClient();
                            HttpResponse resp = httpClient.execute(get);
                            projects.clear();
                            getProjects();
                            insertListView();
                        } catch (Exception e) {
                        }
                    } else {
                        noConnection();
                    }
                }
            });
            if(currentProject.isAfgerond()==true){
                projectSwitch.setEnabled(false);
                naamView.setTextColor(0xFFC0C0C0);
                routeView.setTextColor(0xFFc0c0c0);
            } else {
                projectSwitch.setEnabled(true);
                naamView.setTextColor(0xFF000000);
                routeView.setTextColor(0xFF696969);
            }

            TextView idView = (TextView)itemView.findViewById(R.id.idView);
            idView.setText(currentProject.getId());

            return itemView;
        }
    }

}
