# FOL

**Date**: 18-10-2021

## Info

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

## Resolução dos exercícios

### 2. Instagram+

#### 1. 

Predicados:
- `User(-)`
- `Photo(-)`
- `Day(-) `
- `Ad(-)`
- `Influencer(-)`
- `follows(-,-)`
- `sees(-,-)`
- `posts(-,-)`
- `suggested(-,-)`
- `date(-,-)`


#### 2.

##### (a)

Influencer é um tipo de User:

`∀x. Influencer(x) -> User(x)`

Ad é um tipo de Photo:

`∀x. Ad(x) -> Photo(x)`

##### (b)

As entidades só podem ser Users, Photos ou Days 

`∀x. User(x) <-> ¬Photo(x) ∧ ¬Day(x)`

`∀x. Photo(x) <-> ¬User(x) ∧ ¬Day(x)`

`∀x. Day(x) <-> ¬User(x) ∧ ¬Photo(x)`

##### (c)

Não há nada a adicionar.

##### (d)

`∀x,y. suggested(x,y) -> User(x) ∧ User(y)`

`∀x,y. posts(x,y) -> User(x) ∧ Photo(y)`

`∀x,y. follows(x,y) -> User(x) ∧ User(y)`

`∀x,y. suggested(x,y) -> User(x) ∧ User(y)`

`∀x,y. date(x,y) -> Photo(x) ∧ Day(y)`

##### (e)

Todas as fotos têm uma única data.

`∀x. Photo(x) -> ∃y. date(x,y) ∧ (∀z. date(x,z) -> y = z)`

**ou,**

`∀x. Photo(x) -> (∃y. date(x,y)) ∧ ∀y,z. date(x,y) ∧ date(x,z) -> y = z`

Todos as Photos foram postadas por um único User.

`∀x. Photo(x) -> ∃y. posts(y,x) ∧ (∀z. posts(z,x) -> y = z)`


##### (f)

Influences são seguidos por todos os Users exceto eles próprios.

`∀x,y. Influencer(x) ∧ User(y) ∧ x ≠ y -> follows(y,x)`

Um User não se segue a si próprio.

`∀x,y. User(x) ∧ follows(x,y) -> x ≠ y`

Um User apenas vê Photos (que não sejam Ads) que foram postadas por Users que segue.

`∀x,y. User(x) ∧ sees(x,y) -> Ad(y) ∨ ∃z. posts(z,y) ∧ follows(x,z)`


---

### 3. Courses

#### 1. 

Predicados:
- `Person(-)`
- `Grade(-)`
- `Course(-) `
- `Project(-)`
- `Job(-)`
- `grades(-,-,-)`
- `is_enrolled_in(-,-)`
- `teaches(-,-)`
- `proposes(-,-)`
- `works_on(-,-)`
- `has(-,-)`

Constantes:

- `Professor`
- `Student`

#### 2.

##### (a)

`Job(Professor)`

`Job(Student)`

##### (b)

`∀x. Job(x) <-> ¬Person(x) ∧ ¬Course(x) ∧ ¬Grade(x) ∧ ¬Project(x)`

`∀x. Person(x) <-> ¬Job(x) ∧ ¬Course(x) ∧ ¬Grade(x) ∧ ¬Project(x)`

`∀x. Course(x) <-> ¬Job(x) ∧ ¬Person(x) ∧ ¬Grade(x) ∧ ¬Project(x)`

`∀x. Project(x) <-> ¬Job(x) ∧ ¬Person(x) ∧ ¬Course(x) ∧ ¬Grade(x)`

##### (c)

`Professor ≠ Student`

##### (d)

`∀x,y,z. grades(x,y,z) -> Course(x) ∧ Person(y) ∧ Grade(z)`

`∀x,y. is_enrolled_in(x,y) -> Person(x) ∧ Course(y)`

`∀x,y. teaches(x,y) -> Person(x) ∧ Course(y)`

`∀x,y. proposes(x,y) -> Course(x) ∧ Project(y)`

`∀x,y. works_on(x,y) -> Person(x) ∧ Project(y)`

`∀x,y. has(x,y) -> Person(x) ∧ Job(y)`

##### (e)

Pelo menos uma pessoa trabalhar em cada projeto

`∀x. Project(x) -> ∃y. works_on(y,x)`

Pelo menos uma pessoa ensina cada disciplina

`∀x. Course(x) -> ∃y. teaches(y,x)`

Um projeto é proposto por uma única cadeira

`∀x. Project(x) -> ∃y. proposes(y,x) ∧ (∀z. proposes(z,x) -> z = y)`

É atribuída zero ou uma única nota a cada pessoa a cada disciplina

`∀x. Person(x) ∧ ∃y,z. grades(y,x,z) -> ∀w. grades(y,x,w) -> z = w`

##### (f)

Um estudante apenas trabalha para projetos propostos por disciplinas onde se encontra inscrito e no máximo um projeto por disciplina.

`∀x,y. works_on(x,y) -> ∃z. Course(z) ∧ proposes(z,y) ∧ is_enrolled_in(x,z) ∧ (∀w. works_on(x,w) ∧ proposes(z,w) -> w = y)`

Apenas professores podem ensinar disciplinas.

`∀x,y. Person(x) ∧ teaches(x,y) -> has(x,Professor)`

Apenas estudantes estão inscritos nas disciplinas.

`∀x,y. Person(x) ∧ is_enrolled_in(x,y) -> has(x,Student)`

Um estudante apenas tem nota às cadeiras onde está inscrito

`∀x,y,z. grades(x,y,z) -> is_enrolled_in(y,x)`

---

### 4. File System

#### 1. 

Predicates:

- `Entry(-)`
- `Name(-)`
- `Object(-) `
- `Dir(-)`
- `File(-)`
- `refers_to(-,-)`
- `contains(-,-)`
- `has(-,-)`

Constants:

- `Root`

#### 2.

##### (a)

`Dir(Root)`

`∀x. File(x) -> Object(x)`

`∀x. Dir(x) -> Object(x)`

##### (b)

`∀x. Entry(x) <-> ¬Name(x) ∧ ¬Object(x)`

`∀x. Name(x) <-> ¬Entry(x) ∧ ¬Object(x)`

`∀x. Object(x) <-> ¬Entry(x) ∧ ¬Name(x)`

##### (c)

`∀x. File(x) <-> ¬Dir(x)`

`∀x. Dir(x) <-> ¬File(x)`

##### (d)

`∀x,y. refers_to(x,y) -> Entry(x) ∧ Object(y)`

`∀x,y. has(x,y) -> Entry(x) ∧ Name(y)`

`∀x,y. contains(x,y) -> Dir(x) ∧ Entry(y)`

##### (e)

Entries têm um único Name

`∀x. Entry(x) -> ∃y. has(x,y) ∧ (∀z. has(x,z) -> z = y)`

Uma Dir contém vários ficheiros (0 ou mais)

? (não devia ser preciso dizer nada)

Uma Entry refere um único Object

`∀x. Entry(x) -> ∃y. refers_to(x,y) ∧ (∀z. refers_to(x,z) -> z = y)`

##### (f)

Há uma única Root

`feito em (a)`

Não há mais Objects a não ser Dirs e Files.

`∀x. Object(x) -> Dir(x) ∨ File(x)`

Todos os Objects, exceto a Root, são referidos em pelo menos um Entry (no máximo uma vez, no caso das Dirs).

`∀x. Object(x) ∧ x ≠ Root -> ∃y. refers_to(y,x) ∧ (Dir(x) ∧ ∀z. refers_to(z,x) -> y = z)`

Different entries in the same directory must have different names.

`∀x,y,z. contains(x,y) ∧ contains(x,z) ∧ x ≠ y -> ∃n,m. has(y,n) ∧ has(z,m) -> n ≠ m`

#### 3.

##### (a)

`∀x. Object(x) -> x = Root ∧ ¬(∃y. contains(Root,y))`

##### (b)

`∃x,y,z. Entry(x) ∧ has(x,'cat') ∧ Entry(y) ∧ has(y,'bin') ∧ refers_to(y,z) ∧ contains(Root,z)`

##### (c)

`∃x,y,z,n,m. x ≠ y ≠ z ∧ Entry(x) ∧ Entry(y) ∧ Entry(z) ∧ Entry(n) ∧ has(n,'bin') ∧ refers_to(n,m) ∧ contains(m,x) ∧ contains(m,y) ∧ contains(m,z)`
 
``

---

### 5. Production Line

#### 1.

Predicates:

- `Category(-)`
- `Product(-) `
- `Material(-)`
- `Component(-)`
- `Workstation(-)`
- `Worker(-)`
- `Human(-)`
- `Robot(-)`
- `belongs_to(-,-)`
- `is_built_of(-,-)`
- `is_assembled_at(-,-)`
- `works_at(-,-)`

Constants:

- Dangerous

#### 2.

##### (a)

`Category(Dangerous)`

`∀x. Human(x) -> Worker(x)`

`∀x. Robot(x) -> Worker(x)`

`∀x. Component(x) -> Product(x)`

`∀x. Material(x) -> Product(x)`

##### (b)

`∀x. Category(x) <-> ¬Product(x) ∧ ¬Workstation(x) ∧ ¬Worker(x)`

`∀x. Product(x) <-> ¬Category(x) ∧ ¬Workstation(x) ∧ ¬Worker(x)`

`∀x. Workstation(x) <-> ¬Category(x) ∧ ¬Product(x) ∧ ¬Worker(x)`

`∀x. Worker(x) <-> ¬Category(x) ∧ ¬Product(x) ∧ ¬Workstation(x)`

##### (c)

`∀x. Human(x) <-> ¬Robot(x)`

`∀x. Robot(x) <-> ¬Human(x)`

`∀x. Component(x) <-> ¬Material(x)`

`∀x. Material(x) <-> ¬Component(x)`

##### (d)

`∀x,y. belongs_to(x,y) -> Product(x) ∧ Category(y)`

`∀x,y. is_built_of(x,y) -> Component(x) ∧ Material(y)`

`∀x,y. is_assembled_at(x,y) -> Component(x) ∧ Workstation(y)`

`∀x,y. works_at(x,y) -> Worker(x) ∧ Workstation(y)`

##### (e)

Components are built of one or more Materials.

`∀x. Component(x) -> ∃y. is_built_of(x,y)`

Component is assembled at one (and only one) Workstation

`∀x. Component(x) -> ∃y. is_assembled_at(x,y) ∧ (∀z. is_assembled_at(x,z) -> z = y)`

At least one Worker works at a Workstation. 

`∀x. Workstation(x) -> ∃y. works_at(y,x)`

Workers work at one (and only one) Workstation 

`∀x. Worker(x) -> ∃y. works_at(x,y) ∧ (∀z. works_at(x,z) -> z = y)`

##### (f)

Robots and humans cannot work together

`∀x. Worker(x) -> ∃y. works_at(x,y) ∧ (∀z. works_at(z,y) -> Robot(x) ∧ Robot(z) ∨ Human(x) ∧ Human(z))`

**or**

`∀x. Workstation(x) -> (∀y. works_at(y,x) ∧ Robot(y)) ∨ (∀y. works_at(y,x) ∧ Human(y)))`


Dangerous components must be assembled by robots

`∀x. Component(x) ∧ belongs_to(x,Dangerous) -> ∃z. is_assembled_at(x,z) ∧ (∀w. works_at(w,z) -> Robot(w))`

Products are either materials or components

`answered in (c)`

Components built of dangerous materials are also dangerous.

`∀x. Material(x) ∧ belongs_to(x,Dangerous) -> ∀y. is_built_of(y,x) -> belongs_to(y,Dangerous)`