with darbolavl;
with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;
package destoc is
   type estoc is limited private;

   type marca is (Nike,Adidas,Reebok,Asics,Fila,Puma,Quiksilver,Kappa,Joma,Converse);
   subtype codi is Integer range 0..5000000;
   subtype nom is String(1..20);
   type producte;
   type pproducte is access producte;
   type producte is record
      m: marca;
      n: nom;
      k: codi;
      unitats: integer;
      prev: pproducte; -- anterior en la lista de marca
      next: pproducte; -- siguiente en la lista de marca
   end record;

   mal_uso: exception;
   espacio_desbordado: exception;
   
   -- Prepara l'estructura buida per emmagatzemar els productes
   procedure estoc_buit(c: out estoc);
   -- Introdueix un producte amb una marca, un codi, un nom i un nombre 
   -- d'unitats
   procedure posar_producte(c: in out estoc; m: in marca; k: in codi;
             n: in nom; unitats: in integer);
   -- Esborra el producte amb el codi donat. Nomes ha de poder esborrar-se
   -- si el nombre d'unitats es 0
   procedure esborrar_producte(c: in out estoc; k: in codi);
   -- Imprimeix tots els productes d'una marca (codi, nom i unitats) sense
   -- necessitat de seguir cap ordre.
   procedure imprimir_productes_marca (c: in estoc; m: in marca);
   -- Imprimeix tots els productes de la tenda (codi, nom i unitats) ordenats
   -- ascendentment pel seu codi
   procedure imprimir_estoc_total (c: in estoc);
private
   function menor(k1,k2: in codi) return boolean;
   function major(k1,k2: in codi) return boolean;
   procedure imprimir(x: in pproducte);
   package dnodoarbol is new darbolavl(codi,pproducte,menor,major,imprimir);
   use dnodoarbol;
   type llista_producte is record
      first: pproducte; --puntero al primero
   end record;
   type marcas is array(marca) of llista_producte;
   type estoc is record
      a: arbolavl; --arbol AVL de punteros a productos
      m: marcas; --array de listas de productos
   end record;

end destoc;
