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

    debug_interval,pop_size,i,j,score : integer;
    agent,newguy : gate_network;
    population : gate_network_list; 
    genorations : integer;
    current_agent : gate_network;
    best : integer;
    selection_size,sacrifice,temp1,winner,temp2,better : integer;
    avg : double;

begin
    
    randomize;

    //setup
    population := gate_network_list.create(true);
    genorations := 10000000;
    pop_size := 10000; 
    debug_interval := 100;
    selection_size := 100;
    //populate the list of agents
    for i := 0 to pop_size do population.add(gate_network.create(80,90,500));

    //start evolution
    best := 0;
    for i := 1 to genorations do 
    begin

        //compute every agents fitness
        for current_agent in population do
        begin
            current_agent.reset_buffer();
            current_agent.compute();
            current_agent.fitness := sumint(current_agent.buffer);
        end;
        
        
        //select a strong agent out of ten and sacrifice a random agent
        sacrifice := random(population.count);
        winner := 0;
        for j := 0 to selection_size do 
        begin
            temp1 := random(population.count);
            if population[temp1].fitness > population[winner].fitness then winner := temp1;
        end;
        
        population[sacrifice].genes.gene := copy(population[winner].genes.gene);
        population[sacrifice].genes.mutate();
        population[sacrifice].rebuild();

        //print the strongest of the genorations
        if i mod debug_interval = 0 then
        begin
            //reset the best
            best := 0;
            for j := 0 to population.count - 1 do 
            begin
                if population[j].fitness > population[best].fitness then best := j;
            end;
            //show the best agents buffer(brain)
            for j := 0 to high(population[best].buffer) do write(population[best].buffer[j]);
            write('  GEN  ' , i);
            avg := 0;
            for current_agent in population do
            begin
                avg += current_agent.fitness;
            end;
            avg := avg / (population.count -1);
            write('  AVG  ' , avg:0:2);
            writeln;
        end;

    end;


end.
