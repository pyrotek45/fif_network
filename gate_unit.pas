unit gate_unit;
{$mode objfpc}
interface

uses
    sysutils,
    classes;

type 

    int_p = ^integer;

    fif_gate = class
        gate_input,gate_counter,gate_switch : int_p;
        procedure set_input(_i,_c,_s:int_p);
        function compute():boolean;
        constructor create(_i,_c,_s:int_p);
    end;

implementation

constructor fif_gate.create(_i,_c,_s:int_p);
begin
   self.gate_input := _i;
   self.gate_counter := _c;
   self.gate_switch := _s;
end;

function fif_gate.compute():boolean;
begin
    if self.gate_switch^ = 1 then
    begin
        if self.gate_input^ = self.gate_counter^ then exit(true) else exit(false);
    end
    else
    begin
        if self.gate_input^ >= self.gate_counter^ then exit(true) else exit(false);
    end;
end;

procedure fif_gate.set_input(_i,_c,_s:int_p);
begin
   self.gate_input := _i;
   self.gate_counter := _c;
   self.gate_switch := _s;
end;

end.
