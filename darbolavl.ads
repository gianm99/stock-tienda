with dpila;

generic
   type key is private;
   type item is private;
   with function "<"(k1,k2: in key) return boolean;
   with function ">"(k1,k2: in key) return boolean;
   with procedure print(x: in item);
package darbolavl is
   type arbolavl is limited private;
   mal_uso: exception;
   no_existe: exception;
   ya_existe: exception;
   espacio_desbordado: exception;
   procedure cvacio(s: out arbolavl);
   procedure poner(s: in out arbolavl; k: in key; x: in item);
   procedure consultar(s: in arbolavl; k: in key; x: out item);
   procedure actualizar(s: in arbolavl; k: in key; x: in item);
   procedure borrar(s: in out arbolavl; k: in key);

   --------------
   -- Iterador --
   --------------

   type iterador is limited private;

   procedure first(s: in arbolavl; it: out iterador);
   procedure next(s: in arbolavl; it: in out iterador);
   function is_valid(it: in iterador) return boolean;
   procedure get(s: in arbolavl; it: in iterador; k: out key; x: out item);

   procedure inorden(s: in arbolavl);

private
   type nodo;
   type pnodo is access nodo;
   type factor_balanceo is new integer range -1..1;
   type nodo is record
      k: key;
      x: item;
      bl: factor_balanceo;
      lc, rc: pnodo;
   end record;
   type arbolavl is record
      raiz: pnodo;
   end record;

   package dnodopila is new dpila(pnodo);
   use dnodopila;
   type iterador is record
      st: pila;
   end record;
end darbolavl;
