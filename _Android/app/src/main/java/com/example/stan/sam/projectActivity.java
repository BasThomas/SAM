package com.example.stan.sam;

import android.app.Activity;
import android.content.Intent;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.support.v7.internal.view.menu.MenuView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;


public class projectActivity extends ActionBarActivity {

    private Toolbar toolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_project);
        Bundle bundle = getIntent().getExtras();
        ImageView backButton = (ImageView) findViewById(R.id.backButton);
        backButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        JSONParser jParser = new JSONParser();
        JSONObject json = jParser.getJSONFromUrl("http://i300486.iris.fhict.nl/SAM/projectinfo.php?key=SAMjson&id=" + bundle.getString("id"));
        String projectnaam = "Projectnaam";
        try {
            projectnaam = (String) json.get("projectname");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        TextView projectTitel = (TextView) findViewById(R.id.projectNaam);
        projectTitel.setText(projectnaam);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement


        return super.onOptionsItemSelected(item);
    }
}
