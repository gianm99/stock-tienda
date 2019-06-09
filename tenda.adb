
with Ada.Text_IO, Ada.Integer_Text_IO;
use  Ada.Text_IO, Ada.Integer_Text_IO;

with destoc;
use destoc;
with dpila;
with darbolavl;


procedure tenda is

   stock:estoc;

   procedure menu(st: in out estoc) is
      sel: integer;
      opt: integer;
      last: natural;
      codi: integer;
      u: integer;
      n: String(1..20);
      nnom : nom;      
   begin
      loop
         put_line("---------------------------------");
         put_line("----- Seleccione una opcion -----");
         put_line("---------------------------------");
         put_line(" 1)  Agregar producto al stock");
         put_line(" 2)  Borrar producto del stock");
         put_line(" 3)  Mostrar productos por marca");
         put_line(" 4)  Mostrar todos los productos");
         put_line(" 0)  Salir");
         get(opt); Skip_Line;
         case opt is
            when 1=>
               put_line("*******************************************************************************************************************");
               put_line(" 1)  Agregar producto al stock: ");
               put_line("Identifique la marca:" ); --marca
               put_line("1. Nike   2. Adidas   3. Reebok   4. Asics   5. Fila   6. Puma   7. Quicksilver   8. Kappa   9. Joma   10.Converse");
               get(sel); Skip_Line;
               put_line( marca'Image (marca'Val (sel-1)));
               put_line("Introduzca el codigo del producto:" ); --codigo
               get(codi); Skip_Line;
               put_line("Introduzca el nombre del producto:" ); --nombre
               get_line(n, Last);
               nnom.s(1..last) := n(1..last);
               nnom.l := last;
               put_line("Introduzca la cantidad de unidades del producto:" ); --unidades
               get(u); Skip_Line;
               posar_producte(st, marca'Val (sel-1) , codi, nnom, u); --guardar producto
               put_line("*******************************************************************************************************************");
            when 2 => 
               put_line("*******************************************************************************************************************");
               put_line(" 2)  Borrar producto del stock: ");
               put_line("Introduzca el codigo del producto:" );
               get(codi); Skip_Line;
               esborrar_producte(st, codi); --borrar producto
               put_line("*******************************************************************************************************************");
            when 3 => 
               put_line("*******************************************************************************************************************");
               put_line(" 3)  Mostrar productos por marca: ");
               put_line("Identifique la marca:" );
               put_line("1. Nike    2. Adidas   3. Reebok   4. Asics    5. Fila    6. Puma   7. Quicksilver    8. Kappa    9. Joma  10.Converse   ");
               get(sel); Skip_Line;
               put_line("     CODIGO |    CANTIDAD | NOMBRE");
               put_line("__________________________________");
               imprimir_productes_marca(st, marca'Val (sel-1));
               put_line("*******************************************************************************************************************");
            when 4 =>
               put_line("*******************************************************************************************************************");
               put_line(" 4)  Mostrar todos los productos: ");
               put_line("     CODIGO |    CANTIDAD | NOMBRE");
               put_line("__________________________________");
               destoc.imprimir_estoc_total(stock);
               put_line("*******************************************************************************************************************");
            when 0 =>
               exit;
            when others =>
               null;
         end case;
         New_Line;
      end loop;
   end menu;

begin
   estoc_buit(stock);
   menu(stock);
end tenda;



