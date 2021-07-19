unit network_unit;
{$mode objfpc}
interface

uses
    sysutils,
    gate_unit,
    genome_unit,
    classes;

type 

    gate_network = class
        fitness : integer;
        genes : genome;
        genomesize : integer;
        buffer : array of integer;
        buffersize,gatesize : integer;
        gates : array of fif_gate;
        gate_output : array of int_p;
        constructor create(buffer_size,gate_size,genome_size:integer);
        procedure rebuild();
        procedure reset_buffer();
        function new_offspring():gate_network;
        procedure compute();
    end;

implementation

function booltobit(value:boolean):integer;
begin
    if value then exit(1) else exit(0);
end;

constructor gate_network.create(buffer_size,gate_size,genome_size:integer);
var
    i : integer;
begin
 
    self.genomesize := genome_size;
    self.fitness := 0;
    self.buffersize := buffer_size;
    self.gatesize := gate_size;
    setlength(self.buffer,buffer_size);
    setlength(self.gates,gate_size);
    setlength(self.gate_output,gate_size);

    genes := genome.create(self.genomesize);

    for i := 0 to self.buffersize do self.buffer[i] := 0;

    self.genes.index := 0;

    for i := 0 to self.gatesize do 
        self.gates[i] := fif_gate.create(
        @self.buffer[genes.get_next() mod self.buffersize],
        @self.buffer[genes.get_next() mod self.buffersize],
        @self.buffer[genes.get_next() mod self.buffersize]);

    for i := 0 to self.gatesize do self.gate_output[i] := @self.buffer[genes.get_next() mod self.buffersize]

end;

procedure gate_network.rebuild();
var 
    i : integer;
begin

    self.genes.index := 0;

    for i := 0 to self.gatesize do 
        self.gates[i].set_input(
        @self.buffer[genes.get_next() mod self.buffersize],
        @self.buffer[genes.get_next() mod self.buffersize],
        @self.buffer[genes.get_next() mod self.buffersize]);

    for i := 0 to self.gatesize do self.gate_output[i] := @self.buffer[genes.get_next() mod self.buffersize]

end;

procedure gate_network.compute();
var
    i : integer;
begin

    for i := 0 to high(self.gates) do
    begin
        self.gate_output[i] ^ := booltobit(self.gates[i].compute());
    end;
end;

function gate_network.new_offspring():gate_network;
var 
    temp : gate_network;
begin
    temp := gate_network.create(self.buffersize,self.gatesize,self.genomesize);
    temp.genes := self.genes;
    temp.rebuild();
    exit(temp);
end;

procedure gate_network.reset_buffer();
var
    i : integer;
begin
    for i := 0 to high(self.buffer) do self.buffer[i] := 0;
end;
end.
