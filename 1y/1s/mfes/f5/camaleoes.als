/* 
Complete o seguinte modelo de uma colónia de camaleões onde o número de 
camaleões é fixo mas onde a cor de cada camaleão pode mudar de acordo com
as seguintes regras: 
- As cores possíveis são Verde, Azul e Amarelo
- Se 2 camaleões de cores diferentes se encontram mudam ambos para a terceira cor
- As cores só se alteram na situação acima 
*/

abstract sig Cor {}
one sig Verde, Azul, Amarelo extends Cor {}

sig Camaleao {
	var cor : one Cor,
	var encontro : lone Camaleao
}

fact init {
	no encontro
}

pred nop {
	cor' = cor
	encontro' = encontro
}

pred encontro[x,y : Camaleao] {
	//guard
 	// 1. não é o mesmo camaleão
    x != y
    
	// efect
 	// se os camaleões tiverem cores diferentes mudam para a outra cor
	x.cor != y.cor implies cor' = cor - ((x + y) <: cor) + (x + y)->(Cor - (x + y).cor)
 				   else cor' = cor
	
	encontro' = x->y + y->x	

	// frame conditions
	// implícito 
}

fact Comportamento {
	always (nop or some x,y : Camaleao | encontro[x,y])
}

// Especifique as seguintes propriedades desta colónia

assert Estabilidade {
	// Se os camaleoes ficarem todos da mesma cor, as cores nunca mais mudam
	one Camaleao.cor implies after always one (Camaleao.cor + Camaleao.cor')
}

check Estabilidade for 5

assert NaoConvergencia {
	// Se inicialmente há um camaleao verde e nenhum azul então não é possível
	// que a colónia fique toda amarela
	one cor.Verde and no cor.Azul implies always Camaleao.cor' != Amarelo

}

check NaoConvergencia for 5

// Especifique um cenário onde existe um camaleao que não para de mudar de cor
// tomando recorrentemente todas as cores possíveis

run Exemplo {
	one c : Camaleao | always c.cor != c.cor'
} for 5

// for themes!

fun verdes : set Camaleao {
	cor.Verde
}


fun amarelos : set Camaleao {
	cor.Amarelo
}


fun azuis : set Camaleao {
	cor.Azul
}

// end

