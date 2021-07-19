unit genome_unit;
{$mode objfpc}
interface

uses
    sysutils,
    classes;

type 

    genome = class
        index,size : integer;
        gene : array of integer;
        function get_next():integer;
        constructor create(_size:integer);
        procedure mutate();
    end;

implementation

constructor genome.create(_size:integer);
var
    i : integer;
begin
    self.index := 0;
    self.size := _size;
    setlength(self.gene,_size);
    for i := 0 to high(self.gene) do
    begin
        self.gene[i] := random(255);
    end;
end;

function genome.get_next():integer;
begin 
    if self.index > high(self.gene) then self.index := 0;
    result := gene[index];
    self.index += 1;
end;

procedure genome.mutate();
var
    mutated_gene : integer;
begin
    
    mutated_gene := random(high(self.gene)-1);
    
    if random(2) = 1 then
    begin
        self.gene[mutated_gene] += random(5);
        if self.gene[mutated_gene] >= 255 then self.gene[mutated_gene] := 255;
    end
    else
    begin
        self.gene[mutated_gene] -= random(5);   
        if self.gene[mutated_gene] <= 0 then self.gene[mutated_gene] := 0;
    end;
end;

end.
