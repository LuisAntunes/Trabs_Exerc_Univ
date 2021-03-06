/*
  ###############################################
 ##### Exercicios EDAII - Arvores binarias   #####
  ###############################################
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "bintree.h"
#define TAM 50000



typedef struct TNode { // no de uma arvore binaria
	int elem;

	// filhos direito e esquerdo
	struct TNode *right, *left; 
} TNode;

typedef struct BinTree{ // arvore binaria com uma raiz
	TNode *root;
} BinTree;

//cria e inicializa um novo nó
TNode *node_new(){
	TNode *node = malloc(sizeof(TNode));
	node -> right = NULL;
	node -> left = NULL;
	return node;
}

//cria e inicializa uma arvore
BinTree *tree_new(){
	BinTree *tree = malloc(sizeof(BinTree));
	tree -> root = NULL;
	return tree;
}

bool tree_empty(BinTree *tree){
	return tree -> root == NULL;
}

bool tree_insertAux(TNode **node, int value){
	TNode *tmp = NULL;
	if (!(*node)){
		tmp = node_new();
		tmp -> elem = value;
		*node = tmp;
		return true;
	}
	
	if(value < (*node)->elem)
		tree_insertAux(&(*node) -> left, value);
	
	else if (value > (*node) -> elem)
		tree_insertAux(&(*node) -> right, value);
	
	return false;
}

bool tree_insert(BinTree *tree, int value){
	//verifica se a arvore esta vazia
	//caso esteja altera a raiz para o novo elemento
	TNode *current = tree -> root;
	if(current == NULL){
		current = node_new();
		current -> elem = value;
		tree -> root = current;
		return true;
	}
	else
		tree_insertAux(&current, value); 
}

bool tree_findAux(TNode *node, int value){
	if (!node){
		return false;
	}

	if(value < node->elem)
		tree_findAux(node -> left, value);
	
	else if(value > node -> elem)
		tree_findAux(node -> right, value);

	else if(value == node -> elem)
		return true;

}

bool tree_find(BinTree *tree, int value){
	TNode *current = tree -> root;
	tree_findAux(current, value);

}

// troca o no com o no filho direito com o menor valor
void replaceMinNode(TNode *node, TNode *nodeMinDir){
	TNode tmp = *nodeMinDir;

	if (nodeMinDir -> left == NULL){
		node -> elem = nodeMinDir -> elem;
		nodeMinDir = nodeMinDir -> right;
		//free(tmp);
	}
	else
		replaceMinNode(node, nodeMinDir -> left);
}

bool tree_removeAux(TNode **node, int value){

	TNode *tmp = *node;

	if (!(*node)){
		return false;
	}

	if(value < (*node)-> elem)
		tree_removeAux(&((*node) -> left), value);
	
	else if(value > (*node) -> elem)
		tree_removeAux(&((*node) -> right), value);

	//ha que assegurar que os nos filhos nao se perdem
	else if(value == (*node) -> elem){
		
		if((*node)->left == NULL && (*node)->left == NULL) /* Nó sem descendentes */
			free(node);
		
		else		
		{
			if((*node)->left == NULL)		/* Nó com apenas um descendente Direito */
			{
				*node = (*node)->right;
				free(tmp);
			}
			
			else if((*node)->right == NULL) /* Nó com apenas um descendente Esquerdo */
			{
				*node = (*node)->left;
				free(tmp);
			}
			
			else			/* Nó com dois descendentes */
				replaceMinNode((*node), (*node)->right);
		}		
	}
		
}


bool tree_remove(BinTree *tree, int value){
	TNode *current = tree -> root;
	tree_removeAux(&current, value);
}

void tree_printAux(TNode *node, int level){
	int i;
 
	if (node == NULL) {
		return;
	}
 
	tree_printAux(node->right, level+1);
 
	for (i = 0; i < level; i++)
		printf ("   ");

	printf("%d\n\n", node->elem);
	
	tree_printAux(node->left, level+1);  
}

void tree_print(BinTree *tree){
	tree_printAux(tree -> root, 0);
}

//recebe 2 numeros como arg e devolve o maior desses 2
int max(a, b){
	if (a > b)
		return a;
	else
		return b;
}

// calcula o numero de nos da arvore
int tree_sizeAux(TNode *node) {
	
	if (node == NULL) 
		return 0;
	
	return 1 + tree_sizeAux(node -> left) + tree_sizeAux(node -> right);
}

int tree_size(BinTree *tree){
	tree_sizeAux(tree -> root);
}

// calcula a altura da arvore recursivamente
int tree_heightAux(TNode *node) {
	if (node == NULL)
		return 0;
	return 1 + max(tree_heightAux(node-> left), tree_heightAux(node-> right));
}

int tree_height(BinTree *tree){
	tree_heightAux(tree -> root);
}

void tree_destroyAux(TNode *node){
	if (node != NULL){
		tree_destroyAux(node -> left);
		tree_destroyAux(node -> right);
		free(node);
	}
}

void tree_destroy(BinTree *tree){
	tree_destroyAux(tree -> root);
}

int main(){
	BinTree *tree = tree_new();
	/*tree_insert(tree, 5);
	tree_insert(tree, 7);
	tree_insert(tree, 3);
	tree_insert(tree, 8);
	tree_insert(tree, 1);
	tree_insert(tree, 0);
	tree_insert(tree, 2);
	tree_insert(tree, 6);
	tree_insert(tree, 4);
	//tree_remove(tree, 6);
	printf("%d\n", tree_height(tree));
	printf("%d\n", tree_find(tree, 5));
	tree_print(tree);
	*/
	int i;
	for (i = 0; i < TAM; i++)
		tree_insert(tree, i+1);

	//demora aprox 22 segundos a pesquisar todos os elementos da lista 
	for (i = 0; i < TAM; i++)
		tree_find(tree, i);
	
	tree_destroy(tree);
	
	return 0;
}
