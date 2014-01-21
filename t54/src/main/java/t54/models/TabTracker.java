package t54.models;

import java.util.ArrayList;
import java.util.List;

public class TabTracker
{
    private final List<String> titles = new ArrayList<String>();
    private final List<String> markups = new ArrayList<String>();

    public void addTab(String label, String markup)
    {
        titles.add(label);
        markups.add(markup);
    }

    public List<String> getTitles()
    {
        return titles;
    }

    public List<String> getMarkups()
    {
        return markups;
    }
}
