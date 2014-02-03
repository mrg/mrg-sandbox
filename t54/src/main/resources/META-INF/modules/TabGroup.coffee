# Handle TabGroup tab selections, remembering them across page requests by
# storing them in the browser's sessionStorage object.
#
# The tab selections are stored in a map under the TabGroup key.  The keys in
# the map are the page's name and the value for each page name is a map of tab
# groups for that page.  The map of tab groups contains keys which are the
# tab group's DOM ID and the values are the HREF of the tab within the group.
#
# By using the page's name and the tab group's ID, multiple and nested tabs on
# a page are supported.
#
# Example:
#
#  TabGroup = {"Index" : {"outerTabs":"#outerTabs_tab_0"}}
#
# The page name is "Index" and has one tab group stored ("outerTabs").  The
# tab group's DOM ID is "outerTabs" with an active tab HEF of "#outerTabs_tab_0".
#
# The primary interface is activate(pageName, tabGroupId), but remove(pageName)
# and removeAll() also exist to clear out selections if needed.
#
# This module needs jQuery, UnderscoreJS, and Bootstrap's Tab.
define ["jquery", "underscore", "bootstrap/tab"],
    ($, _) ->
        # The key used to store active tab groups.
        tabGroupKey = "TabGroup"


        # Saves the active tab map.
        #   activeTabMap: The active tab map to save.
        save = (activeTabMap) ->
            sessionStorage.setItem(tabGroupKey, JSON.stringify(activeTabMap))


        # Gets the active tab map or an empty map if missing.
        getActiveTabMap = ->
            JSON.parse(sessionStorage.getItem(tabGroupKey) ? null) ? {}


        # Gets the map of active tabs for a page or an empty map if missing.
        #   activeTabMap: The global active tab map.
        #   pageName: The name of the current page.
        getPageNameMap = (activeTabMap, pageName) ->
            activeTabMap[pageName] ? {}


        # Gets the active tab (HREF) if defined.
        #   pageName: The name of the current page.
        #   tabGroupId: The DOM ID of the TabGroup.
        getActiveTab = (pageName, tabGroupId) ->
            activeTabMap = getActiveTabMap()
            pageNameMap  = getPageNameMap(activeTabMap, pageName)

            pageNameMap[tabGroupId]


        # Sets the active tab.
        #   pageName: The name of the current page.
        #   tabGroupId: The DOM ID of the TabGroup.
        #   activeTab: The #HREF of the active tab.
        setActiveTab = (pageName, tabGroupId, activeTab) ->
            activeTabMap = getActiveTabMap()
            pageNameMap  = getPageNameMap(activeTabMap, pageName)

            # Set/reset the active tab entry.
            pageNameMap[tabGroupId] = activeTab
            activeTabMap[pageName]  = pageNameMap

            # Save updates.
            save(activeTabMap)


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

            # Set up an event listener for when tabs are clicked and record the
            # selection in session storage.
            $("##{tabGroupId} a[data-toggle='tab']").on 'shown.bs.tab', (e) ->
                setActiveTab(pageName, tabGroupId, $(e.target).attr("href"))


        # Remove all active tabs for a page.
        #   pageName: The name of the current page.
        remove = (pageName) ->
            # Get all the keys in the active tab map.
            activeTabMap = getActiveTabMap()

            # Delete the page name entry.
            delete activeTabMap[pageName]

            # Save the new active tab map.
            save(activeTabMap)


        # Remove all active tabs.
        removeAll = ->
            sessionStorage.removeItem(tabGroupKey)


        # Exports.
        { activate, remove, removeAll }
