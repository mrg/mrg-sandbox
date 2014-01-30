# Handle TabGroup Tab selections, remembering them across page requests.
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
            activeTab = getActiveTab(pageName, tabGroupId)

            # If the Tab ID has been set, show that tab again,
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
            # Get the keys in the active tab map.
            activeTabMap = getActiveTabMap()
            keys         = _.keys(activeTabMap)

            # Loop over all the keys in the active tab map, rejecting the ones
            # that match the page name, leaving a list of keys to keep.
            keys = _.reject keys, (key) ->
                key.indexOf(pageName + "_") == 0

            # Create a new map of remaining active tabs.
            map = {}

            # Build the map based upon non-rejected keys.
            for key in keys
                map[key] = activeTabMap[key]

            # Save the new active tab map.
            sessionStorage.setItem(tabGroupKey, JSON.stringify(activeTabMap))


        # Remove all active tabs.
        removeAll = ->
            sessionStorage.removeItem(tabGroupKey)


        # Exports.
        { activate, remove, removeAll }
