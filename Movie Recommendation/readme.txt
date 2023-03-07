Attribute: Movie API use TMDb

Extra credit:

    Studio 3 is completed and submitted
    3D touch action supported for collection view item

Creative Feature
1. What you implemented
    A: In each detail page of the movie, A trailer is displayed and can be played if there is one

    Note that Not all movie has trailer and recommdations, those are only displayed when api return vaild ones

    B: The Third Section in tab controller, shows the movies that are currently playing

    C: In each detail page of the movie, Recommendation section in the very buttom shows recommednedd movie by TMBD APi
        User can further click into the detailed page recusively, with all feature maintained

    D: Favorite button in detail page shows filled and empty when the movie is starred or not, hit favorite button
        on favorited movie can delete the favorite



2. How you implemented it
    A.
        use movie id, fetch another video query, get video address,
        if available, emmbed in webkit and display on scroll view

    B.
        Create another section, fetch data using api with another query
        display the movies that are now playing, poster is replaced with default image if necessary
    C.
        Fetch another api with the movie id of the page, if there is any recommaned movies,
        add to scroll view, adjust the size, layout, update scrollview's frame
    D.
        Read from user default, two array contains id and title is stored in user default.
        Check if id in favorited id list, and show the image with respect. likewise for favorite action



3. Why you implemented it
    A.
        A trailer can help us futher feel the movie. It can bring user the experience that text and image cannot
    B.
        For user that plan to see a movie offline, or user who check new movies from time to time. It brings a convient portal
    C.
        When user discover movie they like, they are very likely to explore some simarlr ones. Keeping recommmendat movies,
        user can revursivly discover movies they like. This can increase user engagement and duration.
    D.
        Easier for user to delete from favorite, user would not have to go to another separated page to do so, improve user's
        experience
