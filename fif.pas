program fif;
{$mode objfpc}

uses
    math,
    generics.collections,
    sysutils,
    classes,
    gate_unit,
    network_unit,
    genome_unit;

type
    gate_network_list = specialize tobjectlist<gate_network>;

var

    i,j,sum : integer;
    agent,newguy : gate_network;
    population : gate_network_list; 

    genorations : integer;
    current_agent : gate_network;

    sacrifice,temp1,temp2,better : integer;
begin
    
    randomize;

    population := gate_network_list.create(true);
    for i := 0 to 100 do population.add(gate_network.create(20,30,20));
    
    genorations := 10;
    for i := 1 to 100000000 do 
    begin
        //writeln('gen  ' + inttostr(i));
        for current_agent in population do
        begin
            current_agent.reset_buffer();
            current_agent.compute();
            sum := 0;
            for j := 0 to high(current_agent.buffer) do sum += current_agent.buffer[j];
            current_agent.fitness := sum;
            //for j := 0 to high(current_agent.buffer) do write(current_agent.buffer[j]);
            //writeln('   sum  ' + inttostr(sum));
        end;
        
        temp1 := random(101);
        temp2 := random(101);
        
        if population[temp1].fitness >= population[temp2].fitness then
        begin
            sacrifice := temp2;
            better := temp1;
            population[sacrifice].genes.gene := copy(population[temp1].genes.gene,0,length(population[temp1].genes.gene));
            population[sacrifice].genes.mutate();
            population[sacrifice].morph();
            //for j := 0 to high(population[temp1].buffer) do write(population[temp1].buffer[j]);
        end
        else
        begin
            sacrifice := temp1; 
            better := temp2;
            population[sacrifice].genes.gene := copy(population[temp2].genes.gene,0,length(population[temp2].genes.gene));
            //population[sacrifice].genes.mutate();
            population[sacrifice].morph();
            //for j := 0 to high(population[temp2].buffer) do write(population[temp2].buffer[j]);
        end;

        //writeln('the sacrifice is index ' + inttostr(sacrifice));
        if i mod 1000 = 0 then
        begin
            for j := 0 to high(population[better].buffer) do write(population[better].buffer[j]);
            write('     ' + inttostr(i));
            writeln;
        end;

    end;


end.
