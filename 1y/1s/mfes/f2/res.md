# FOL

**Data**: 18-10-2021

## Informações sobre o aluno

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

`∀x,y. suggested(x,y) -> User(x) ∧ User(y)

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
- `Professor(-)`
- `Student(-)`
- `grades(-,-,-)`
- `is_enrolled_in(-,-)`
- `teaches(-,-)`
- `proposes(-,-)`
- `works_on(-,-)`
- `has(-,-)`

#### 2.

##### (a)

`∀x. Professor(x) -> Job(x)`

`∀x. Student(x) -> Job(x)`

##### (b)

`∀x. Job(x) <-> ¬Person(x) ∧ ¬Course(x) ∧ ¬Grade(x) ∧ ¬Project(x)`

`∀x. Person(x) <-> ¬Job(x) ∧ ¬Course(x) ∧ ¬Grade(x) ∧ ¬Project(x)`

`∀x. Course(x) <-> ¬Job(x) ∧ ¬Person(x) ∧ ¬Grade(x) ∧ ¬Project(x)`

`∀x. Project(x) <-> ¬Job(x) ∧ ¬Person(x) ∧ ¬Course(x) ∧ ¬Grade(x)`

##### (c)

`∀x. Student(x) <-> ¬Professor(x)`

`∀x. Professor(x) <-> ¬Student(x)`

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

?

##### (f)

Um estudante apenas trabalha para projetos propostos por disciplinas onde se encontra inscrito e no máximo um projeto por disciplina.

`∀x,y. works_on(x,y) -> ∃z. Course(z) ∧ proposes(z,y) ∧ is_enrolled_in(x,z) ∧ (∀w. works_on(x,w) ∧ proposes(z,w) -> w = y)`

Apenas professores podem ensinar disciplinas.

`∀x,y. teaches(x,y) -> Professor(x)`

Apenas estudantes estão inscritos nas disciplinas.

`∀x,y. is_enrolled_in(x,y) -> Student(x)`

Um estudante apenas tem nota às cadeiras onde está inscrito

`∀x,y,z. grades(x,y,z) -> is_enrolled_in(y,x)`


### 4. File System

#### 1. 

- `Entry(-)`
- `Name(-)`
- `Object(-) `
- `Dir(-)`
- `File(-)`
- `Root(-)`
- `refers_to(-,-)`
- `contains(-,-)`
- `has(-,-)`

#### 2.

##### (a)

`∀x. Root(x) -> Dir(x)`

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

`∃x. Root(x) ∧ (∀y. Root(y) -> x = y)`

Não há mais Objects a não ser Dirs e Files.

`∀x. Object(x) -> Dir(x) ∨ File(x)`

Todos os Objects, exceto a Root, são referidos em pelo menos um Entry (no máximo uma vez, no caso das Dirs).

`∀x. Object(x) ∧ ¬Root(x) -> ∃y. refers_to(y,x) ∧ (Dir(x) ∧ ∀z. refers_to(z,x) -> y = z)`

#### 3.

##### (a)

`∀x. Root(x) ∧ ¬(∃y. contains(x,y))`

##### (b)

?

##### (c)

?

### 5. Production Line

#### 1.