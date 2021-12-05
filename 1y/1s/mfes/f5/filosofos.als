// Modelo do jantar dos filósofos

// As "coisas" à volta da mesa
abstract sig Coisa {
	prox : one Coisa
}

sig Filosofo extends Coisa {
	// Garfos que cada filósofo tem na mão
	var garfos : set Garfo
}

sig Garfo extends Coisa {}

// Especifique a configuração da mesa
fact Mesa {
	// A mesa é redonda, ou seja, as coisas formam um anel
	Coisa->Coisa = ^prox

	// Os garfos e os filósofos estão intercalados
	Garfo.prox = Filosofo
	Filosofo.prox = Garfo
}

// Especifique os seguintes eventos

// Um filosofo pode comer se já tiver os dois garfos junto a si
// e pousa os garfos depois
pred come [f : Filosofo] {
	// guard
	(f.prox + prox.f) = f.garfos
	
    //effect
    garfos' = garfos - f->(f.prox + prox.f)
}

// Um filósofo pode pegar num dos garfos que estejam
// pousados junto a si
pred pega [f : Filosofo] {
	// guard 
	// Existe pelo menos um garfo para o filósofo pegar
	f.prox not in f.garfos or prox.f not in f.garfos
	
	// effect
	f.prox in f.garfos implies garfos' = garfos + f->prox.f
	prox.f in f.garfos implies garfos' = garfos + f->f.prox

}

// Para além de comer ou pegar em garfos os filósofos podem pensar
pred pensa [f : Filosofo] {
	garfos' = garfos
}

fact Comportamento {
	// No inicio os garfos estão todos pousados
	no garfos
	// Depois os filósfos só podem comer, pegar ou pensar
	always (some f : Filosofo | come[f] or pega[f] or pensa[f])
}

// Especifique as seguintes propriedades

assert GarfosNaMao {
	// O mesmo garfo nunca pode estar na mão de dois filósofos
	all g : Garfo | lone garfos.g
}
check GarfosNaMao for 6

assert SempreQuePegaCome {
	// Qualquer filósofo que pega num garfo vai conseguir comer
	all f : garfos.Garfo | eventually come[f]
}
check SempreQuePegaCome for 6

assert SemBloqueio {
	// O sistema não pode bloquear numa situação em que só é possível pensar
	(no f : Filosofo | come[f] or pega[f]) implies eventually (some f : Filosofo | not pensa[f] )
}
check SemBloqueio for 6

// Especifique um cenário com 4 filósofos onde todos conseguem comer
run Exemplo {

# Filosofo = 4
all f : Filosofo | eventually come[f]

} for 10
