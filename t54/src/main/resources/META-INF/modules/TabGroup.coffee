# Handle TabGroup Tab selections, remembering them across page requests.
define ["bootstrap/tab", "jquery", "jquery.cookie"],
    (tab, $) ->
        # Activates a previously selected tab or selects the first tab.
        #   pageName: The name of the current page.
        #   tabGroupId: The DOM ID of the TabGroup.
        activate = (pageName, tabGroupId) ->
            # The name of the cookie is based on the Page Name and TabGroup DOM ID.
            cookieName = "#{pageName}_tabgroup_#{tabGroupId}"

            # The Tab ID is the value of the cookie.
            tabId = $.cookie(cookieName)

            # If the Tab ID has been set, show that tab again,
            # otherwise show the first tab.
            if tabId?
                $("##{tabGroupId} a[href='#{tabId}']").tab("show")
            else
                $("##{tabGroupId} a:first").tab("show")

            # Set up an event listener for when tabs are shown and record the
            # selection in a session cookie.
            $("##{tabGroupId} a[data-toggle='tab']").on 'shown.bs.tab', (e) ->
                $.cookie(cookieName, $(e.target).attr("href"))

        # Exports.
        { activate }
