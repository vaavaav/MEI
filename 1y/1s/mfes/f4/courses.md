# Alloy : Courses

**Data**: 15-11-2021

## Info

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

## Resolução

[Link do Modelo no Alloy4Fun](http://alloy4fun.inesctec.pt/ujcjigh4BD865xWET)

```als
open util/ordering[Grade]

sig Person {
	teaches : set Course,
	enrolled : set Course,
	projects : set Project
}

sig Professor,Student in Person {}

sig Course {
	projects : set Project,
	grades : Person -> Grade
}

sig Project {}

sig Grade {}

// Specify the following properties
// You can check their correctness with the different commands and
// when specifying each property you can assume all the previous ones to be true

pred inv1 {
	// Only students can be enrolled in courses
  	// Student <: enrolled = enrolled
	enrolled.Course in Student
  
}


pred inv2 {
	// Only professors can teach courses
  	// Professor <: teaches = teaches
  	teaches.Course in Professor
	
}


pred inv3 {
	// Courses must have teachers
	Professor.teaches = Course
}


pred inv4 {
	// Projects are proposed by one course
	(Course <: projects) in Course one -> set Project
}


pred inv5 {
	// Only students work on projects and 
	// projects must have someone working on them
	
	Person.projects - (Person - Student).projects = Project 
  	
  	// or (more obvious)
    // no ((Person - Student) <: projects)
  	// Person.projects = Projects
  
}


pred inv6 {
	// Students only work on projects of courses they are enrolled in
  	(Student <: projects).(~projects :> Course) in enrolled

}


pred inv7 {
	// Students work on at most one project per course
  	all s : Student, c : Course | lone ((s.projects) & (c.projects))
	
}


pred inv8 {
	// A professor cannot teach herself
	no (teaches & enrolled)
}


pred inv9 {
	// A professor cannot teach colleagues
  	 no(teaches & (Professor <: enrolled).~teaches.teaches)
}


pred inv10 {
	// Only students have grades
  	Course.grades.Grade in Student

}


pred inv11 {
	// Students only have grades in courses they are enrolled
	~(grades.Grade) in enrolled	
}


pred inv12 {
	// Students have at most one grade per course
  	//all s : Student, c : Course | lone (s.(c.grades))
	grades in Course set -> set Person -> lone Grade 
}


pred inv13 {
	// A student with the highest mark in a course must have worked on a project on that course
  	//all c : Course, s : Student | s.enrolled = c and s.(c.grades) = max[Student.(c.grades)] implies one (c.projects & s.projects) 
	
}


pred inv14 {
	// A student cannot work with the same student in different projects
	all s,t : Student | s != t implies lone (s.projects & t.projects)
}


pred inv15 {
	// Students working on the same project in a course cannot have marks differing by more than one unit
   //all p : Project, s : Student | s in projects.p implies s.((projects.p).grades) 
}
```