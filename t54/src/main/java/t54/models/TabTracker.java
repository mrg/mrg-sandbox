package t54.models;

import java.util.ArrayList;
import java.util.List;

public class TabTracker
{
    private final List<String> titles = new ArrayList<String>();
    private final List<String> requiredIndicators = new ArrayList<String>();
    private final List<String> markups = new ArrayList<String>();

    public void addTab(String title, String requiredIndicator, String markup)
    {
        titles.add(title);
        requiredIndicators.add(requiredIndicator);
        markups.add(markup);
    }

    public List<String> getTitles()
    {
        return titles;
    }

    public List<String> getRequiredIndicators()
    {
        return requiredIndicators;
    }

    public List<String> getMarkups()
    {
        return markups;
    }
}
