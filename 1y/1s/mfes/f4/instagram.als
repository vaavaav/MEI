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
	all y : Photo | one x : User | x->y in posts 
}


pred inv2 {
	// An user cannot follow itself.
	all x : User | not (x->x in follows) 
}


pred inv3 {
	// An user only sees (non ad) photos posted by followed users. 
	// Ads can be seen by everyone.
	all x : User, y : Photo | some z : User | x->y in sees => y in Ad or (z->y in posts and x->z in follows)
}


pred inv4 {
	// If an user posts an ad then all its posts should be labelled as ads 
	all y : Ad | one x : User | x->y in posts and all z : Photo | x->z in posts implies z in Ad  
}


pred inv5 {
	// Influencers are followed by everyone else
  all x : Influencer, y : User | x != y implies y->x in follows 

}


pred inv6 {
	// Influencers post every day

}


pred inv7 {
	// Suggested are other users followed by followers but not yet followed
	
}


pred inv8 {
	// An user only sees ads from followed or suggested users

}
