# FOL

**Data**: 18-10-2021

## Informações sobre o aluno

**Nome**: José Pedro Ribeiro Peixoto<br>
**Número**: PG47381<br>
**Curso**: Mestrado em Engenharia Informática<br>

## Resolução dos exercícios

### 1. Instagram

---
### 2. Instagram+

**1.** 

Predicados:
- User(-)
- Photo(-)
- Day(-) 
- Ad(-)
- Influencer(-)
- follows(-,-)
- sees(-,-)
- posts(-,-)
- suggested(-,-)
- date(-,-)


**2.**
**(b)** 

Influencer é um tipo de User:

`∀x. Influencer(x) -> User(x)`

As entidades só podem ser Users, Photos ou Days 

`∀x. User(x) <-> ¬Photo(x) ∧ ¬Day(x)`
`∀x. Photo(x) <-> ¬User(x) ∧ ¬Day(x)`
`∀x. Day(x) <-> ¬User(x) ∧ ¬Photo(x)`

**(d)**

`∀x,y. suggested(x,y) -> User(x) ∧ User(y)`
`∀x,y. date(x,y) -> Photo(x) ∧ Day(y)`

**(e)**

Todas as fotos têm uma única data.

`∀x. Photo(x) -> ∃y. date(x,y) ∧ ∀z. date(x,z) -> y = z`

**ou,**

`∀x. Photo(x) -> (∃y. date(x,y)) ∧ ∀y,z. date(x,y) ∧ date(x,z) -> y = z`

**(f)**

`∀x,y. Influencer(x) ∧ User(y) ∧ x ≠ y -> follows(y,x)`


---

**3.**

**(d)**

`∀x,y,z. Project(y) -> ∃x. Person(x) ∧ workson(x,y)`

**(f)**

`∀x,y. workson(x,y) -> ∃x.∧ Course(z) ∧ proposes(z,y) ∧ isenrolledin(x,z) ∧ (∀w. workson(x,w) ∧ proposes(z,w) -> w = y)`


