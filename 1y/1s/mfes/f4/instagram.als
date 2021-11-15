sig User {
	follows : set User,
	sees : set Photo,
	posts : set Photo,
	suggested : set User
}

sig Influencer extends User {}

sig Photo {
	date : one Day
}
sig Ad extends Photo {}

sig Day {}

// Specify the following properties
// You can check their correctness with the different commands and
// when specifying each property you can assume all the previous ones to be true

pred inv1 {
	// Every image is posted by one user
	posts in (User one -> Photo)

}


pred inv2 {
	// An user cannot follow itself.
	no (iden & follows)
}


pred inv3 {
	// An user only sees (non ad) photos posted by followed users. 
	// Ads can be seen by everyone.
	sees in (follows.posts + User->Ad) 
}


pred inv4 {
	// If an user posts an ad then all its posts should be labelled as ads 
	no (posts.Ad & posts.(Photo - Ad))
}


pred inv5 {
	// Influencers are followed by everyone else
	(User->Influencer - iden) in follows 

}


pred inv6 {
	// Influencers post every day
	Influencer <: (posts.date) = Influencer->Day 
}


pred inv7 {
	// Suggested are other users followed by followers but not yet followed
	
}


pred inv8 {
	// An user only sees ads from followed or suggested users

}
