# Handle TabGroup tab selections, remembering them across page requests by
# storing them in the browser's sessionStorage object.
#
# The tab selections are stored in a map under the TabGroup key.  The keys in
# the map are the page's name, an underscore, and the tab group's DOM ID.  By
# using the page's name and the tab group's ID, multiple and nested tabs on a
# page are supported.  The map's value is the HREF of the tab within the group.
#
# Example:
#
#  TabGroup = {"Index_outerTabs":"#outerTabs_tab_0"}
#
# The page name is "Index" and the tab group ID is "outerTabs".  If there were
# more selections, there'd be more key/value pairings in the map.
#
# The primary interface is activate(pageName, tabGroupId), but remove(pageName)
# and removeAll() also exist to clear out selections if needed.
define ["jquery", "underscore", "bootstrap/tab"],
    ($, _) ->
        # The key used to store active tab groups.
        tabGroupKey = "TabGroup"


        # Gets the active tab map or an empty map if missing.
        getActiveTabMap = ->
            JSON.parse(sessionStorage.getItem(tabGroupKey) ? null) ? {}


        # Gets the active tab key.
        #   pageName: The name of the current page.
        #   tabGroupId: The DOM ID of the TabGroup.
        getActiveTabKey = (pageName, tabGroupId) ->
            "#{pageName}_#{tabGroupId}"


        # Gets the active tab.
        #   pageName: The name of the current page.
        #   tabGroupId: The DOM ID of the TabGroup.
        getActiveTab = (pageName, tabGroupId) ->
            activeTabMap = getActiveTabMap()
            activeTabKey = getActiveTabKey(pageName,tabGroupId)

            activeTabMap[activeTabKey]


        # Sets the active tab.
        #   pageName: The name of the current page.
        #   tabGroupId: The DOM ID of the TabGroup.
        #   activeTab: The #href of the active tab.
        setActiveTab = (pageName, tabGroupId, activeTab) ->
            activeTabMap               = getActiveTabMap()
            activeTabKey               = getActiveTabKey(pageName,tabGroupId)
            activeTabMap[activeTabKey] = activeTab

            # Save updates.
            sessionStorage.setItem(tabGroupKey, JSON.stringify(activeTabMap))


        # Activates a previously selected tab or selects the first tab.
        #   pageName: The name of the current page.
        #   tabGroupId: The DOM ID of the TabGroup.
        activate = (pageName, tabGroupId) ->
            # Get the active tab (if present).
            activeTab = getActiveTab(pageName, tabGroupId)

            # If the active tab exists, show that tab again,
            # otherwise show the first tab.
            if activeTab?
                $("##{tabGroupId} a[href='#{activeTab}']").tab("show")
            else
                $("##{tabGroupId} a:first").tab("show")

            # Set up an event listener for when tabs are shown and record the
            # selection in the session.
            $("##{tabGroupId} a[data-toggle='tab']").on 'shown.bs.tab', (e) ->
                setActiveTab(pageName, tabGroupId, $(e.target).attr("href"))


        # Remove all active tabs for a page.
        #   pageName: The name of the current page.
        remove = (pageName) ->
            # Get all the keys in the active tab map.
            activeTabMap = getActiveTabMap()
            keys         = _.keys(activeTabMap)

            # Loop over all the keys in the active tab map, rejecting the ones
            # that match the page name, giving us a new list of keys to keep.
            # Must use the page name's prefix to match all tabs on a page.
            keys = _.reject keys, (key) ->
                pageNamePrefix = "#{pageName}_"
                key.indexOf(pageNamePrefix) == 0

            # Create a new map for the remaining active tabs.
            map = {}

            # Populate the map based upon non-rejected keys.
            for key in keys
                map[key] = activeTabMap[key]

            # Save the new active tab map.
            sessionStorage.setItem(tabGroupKey, JSON.stringify(activeTabMap))


        # Remove all active tabs.
        removeAll = ->
            sessionStorage.removeItem(tabGroupKey)


        # Exports.
        { activate, remove, removeAll }
