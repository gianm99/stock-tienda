package body destoc is
   -----------------------------------------
   -- Procedimientos privados del package --
   -----------------------------------------

   function menor(k1,k2: in codi) return boolean is
   begin
      return k1<k2;
   end menor;
   
   function major(k1,k2: in codi) return boolean is
   begin
      return k1>k2;
   end major;

   procedure imprimir(x: in pproducte) is 
      k: codi renames x.k;
      n: nom renames x.n;
      unitats: integer renames x.unitats; 
   begin
      Ada.Integer_Text_IO.Put(k);
      Put(" - ");
      Ada.Text_IO.Put(n);
      Put(" - ");
      Put(unitats);
      New_Line;
   end imprimir;

   -----------------------------------------
   -- Procedimientos publicos del package --
   -----------------------------------------

   -- Prepara l'estructura buida per emmagatzemar els productes
   procedure estoc_buit(c: out estoc) is
   begin
      cvacio(c.a);
      for I in marca loop
         c.m(I).first:=null;
      end loop;
   end estoc_buit;

   -- Introdueix un producte amb una marca, un codi, un nom i un nombre 
   -- d'unitats
   procedure posar_producte(c: in out estoc; m: in marca; k: in codi;n: in nom; 
                            unitats: in integer) is
      pp: pproducte;
   begin
      pp:= new producte;
      pp.m:=m; --marca
      pp.n:=n; --nom
      pp.k:=k; --codi
      pp.unitats:=unitats; --unitats
      --posicion en la lista
      pp.prev:=null; --no tiene anterior
      pp.next:=c.m(m).first;
      c.m(m).first:=pp; --primero
      --posicion en el arbol
      poner(c.a,k,pp);
   exception
      when dnodoarbol.ya_existe => raise destoc.mal_uso;
      when dnodoarbol.espacio_desbordado=> raise destoc.espacio_desbordado;
   end posar_producte;

   -- Esborra el producte amb el codi donat. Nomes ha de poder esborrar-se
   -- si el nombre d'unitats es 0
   procedure esborrar_producte(c: in out estoc; k: in codi) is
      pp: pproducte;
   begin
      consultar(c.a,k,pp);
      if pp.unitats=0 then
         --borrar de su lista
         if c.m(pp.m).first=null then --lista vacia
            raise destoc.mal_uso;
         end if;
         if pp=c.m(pp.m).first then --primero
            c.m(pp.m).first:=pp.next;
         end if;
         if pp.next/=null then --no es el ultimo
            pp.next.prev:=pp.prev;
         end if;
         if pp.prev/=null then -- no es el primero
            pp.prev.next:=pp.next;
         end if;
         --borrar del arbol
         borrar(c.a,k);
      else
         raise destoc.mal_uso;
      end if;
   exception
      when dnodoarbol.no_existe => raise destoc.mal_uso;
   end esborrar_producte;

   -- Imprimeix tots els productes d'una marca (codi, nom i unitats) sense
   -- necessitat de seguir cap ordre.
   procedure imprimir_productes_marca (c: in estoc; m: in marca) is
      pp: pproducte;
   begin
      pp:=c.m(m).first;
      while pp/= null loop
         imprimir(pp);
         pp:=pp.next;
      end loop;
   end imprimir_productes_marca;

   -- Imprimeix tots els productes de la tenda (codi, nom i unitats) ordenats
   -- ascendentment pel seu codi
   procedure imprimir_estoc_total (c: in estoc) is
   begin
      inorden(c.a);
   end imprimir_estoc_total;
   
end destoc;
