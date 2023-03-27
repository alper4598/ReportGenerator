clc

import mlreportgen.report.*
import slreportgen.report.*
import slreportgen.finder.*
import mlreportgen.dom.*
import mlreportgen.utils.*
import systemcomposer.query.*
import systemcomposer.rptgen.finder.*

rpt_type = 'pdf';
[file, path] = uiputfile('*.pdf');
rpt = Report([path file],rpt_type); % Create an empty PDF document
open(rpt);

%% Chapters
% 
% ch1 = Chapter();
% ch1.Title = 'First Chapter';
% sec = Section('First Section of Chapter 1');
% txt = ['This is the first section of chapter 1. ',...
%       'The first page number for this ',...
%       'chapter is 1, which is the default. ',...
%       'The page orientation is also the default.']; 
% append(sec,txt);
% append(ch1,sec);
% append(rpt,ch1); 

% Example content - add your own content here
add(rpt, mlreportgen.dom.Heading1('System Composer Model Architecture'));
add(rpt, 'This is the introduction section.');

add(rpt, mlreportgen.dom.Heading1('Methodology'));
add(rpt, 'This is the methodology section.');

p1 = Paragraph("This is a paragraph with a bottom outer margin of 50pt.");
p1.Style = {OuterMargin("0pt", "0pt","0pt","90pt")};

append(rpt, p1);

Image1 = Image("C:\Users\alperen.sever\Desktop\SystemComposerApplication\JE_logo.png");
Image1.Width = "5in";
Image1.Height = "2in";

append(rpt,Image1);


% add(rpt, mlreportgen.dom.PageBreak);



%% Cover Config


title_page = TitlePage();


% set properties of rhe Title Page reporter
title_page.Title = 'Software Architecture Design';
title_page.Author = 'Author';
title_page.Subtitle = 'Subtitle';
title_page.PubDate = date;

add(rpt, PageBreak);


%% Table of Content

toc = TableOfContents;
toc.Title = Text("Table of Content");
toc.Title.Color = "orange";
append(rpt,toc);

add(rpt,PageBreak);




%% Cover Page


title_page = TitlePage();


% set properties of rhe Title Page reporter


title_page.Title = Text('System Variable Report ');
title_page.Author = 'Author';
title_page.Subtitle = 'Parameters and Signal Tables';
title_page.PubDate = date;
title_page.Title.Color = "orange";

% add the reporter ("title_page") to the report ("rpt")
append(rpt, title_page);



%% Table Sets

%Table for Parameters

tableStyleforParameter = ...
    { ...
    Width("100%"), ...
    Border("solid"), ...
    RowSep("solid"), ...
    ColSep("solid") ...
    };

tableEntriesStyleforParameter = ...
    { ...
    HAlign("center"), ...
    VAlign("middle") ...
    };

headerRowStyleforParameter = ...
    { ...
    InnerMargin("5pt","5pt","5pt","5pt"), ...
    BackgroundColor("orange"), ...
    Bold(true) ...
    };

headerContentforParameter = ...
    { ...
    'Parameter', 'Data Type', 'Dimension','Value','Complexity' ...
    };

grps(1) = TableColSpecGroup;
grps(1).Span = 3;

specs(1) = TableColSpec;
specs(1).Span = 2;
specs(1).Style = {Width("15%")};

specs(2) = TableColSpec;
specs(2).Span = 1;
specs(2).Style = {Width("15%")};

grps(1).ColSpecs = specs;

% Table for Signals

tableStyleforSignal = ...
    { ...
    Width("100%"), ...
    Border("solid"), ...
    RowSep("solid"), ...
    ColSep("solid") ...
    };

tableEntriesStyleforSignal = ...
    { ...
    HAlign("center"), ...
    VAlign("middle") ...
    };

headerRowStyleforSignal = ...
    { ...
    InnerMargin("5pt","5pt","5pt","5pt"), ...
    BackgroundColor("orange"), ...
    Bold(true) ...
    };

headerContentforSignal = ...
    { ...
    'Signal', 'Data Type','Min','Max','Initial Value','Complexity','Sample Time' ...
    };

grps(1) = TableColSpecGroup;
grps(1).Span = 3;

specs(1) = TableColSpec;
specs(1).Span = 2;
specs(1).Style = {Width("17%")};

specs(2) = TableColSpec;
specs(2).Span = 1;
specs(2).Style = {Width("15%")};

grps(1).ColSpecs = specs;

Workspace = whos
BodyContentforParameter ={};
BodyContentforSignal ={};

for N=1:length(Workspace)
    VarInfo = evalin('base',Workspace(N).name);
    if isa(VarInfo,'mpt.Parameter')
        
        IndexList = {Workspace(N).name,VarInfo.DataType,VarInfo.Dimensions,VarInfo.Value,VarInfo.Complexity};
        for M=1:length(IndexList)
            BodyContentforParameter(N,M) = IndexList(M);
        end
    elseif isa(VarInfo,'mpt.Signal')
        
        IndexList_ = {Workspace(N).name,VarInfo.DataType,VarInfo.Min,VarInfo.Max,VarInfo.InitialValue,VarInfo.Complexity,VarInfo.SampleTime};
        for K=1:length(IndexList_)
            BodyContentforSignal(N,K) = IndexList_(K);
        end
    else
        %Do Nothing
    end
end
DeleteEmptyCells =[];

emptyCells = cellfun(@isempty,BodyContentforParameter);
for N=1:length(emptyCells)
   if emptyCells(N,1)
       DeleteEmptyCells(end+1) = N;
      
   end
end
 BodyContentforParameter(DeleteEmptyCells,:) = [];

DeleteEmptyCells =[];

emptyCells = cellfun(@isempty,BodyContentforSignal);
for N=1:length(emptyCells)
   if emptyCells(N,1)
       DeleteEmptyCells(end+1) = N;
      
   end
end
 BodyContentforSignal(DeleteEmptyCells,:) = [];


%% Parameter Table

add(rpt,Heading1("Parameter Table"));
tableContentforParameter = [headerContentforParameter; BodyContentforParameter];

tableforParameter = Table(tableContentforParameter);
tableforParameter.ColSpecGroups = grps;

tableforParameter.Style = tableStyleforParameter;
tableforParameter.TableEntriesStyle = tableEntriesStyleforParameter;

firstRow = tableforParameter.Children(1);
firstRow.Style = headerRowStyleforParameter; 

append(rpt,tableforParameter);
add(rpt, mlreportgen.dom.PageBreak);

%% Signal Table

add(rpt,Heading1("Signal Table"));
tableContentforSignal = [headerContentforSignal; BodyContentforSignal];

tableforSignal = Table(tableContentforSignal);
tableforSignal.ColSpecGroups = grps;

tableforSignal.Style = tableStyleforSignal;
tableforSignal.TableEntriesStyle = tableEntriesStyleforSignal;

firstRow = tableforSignal.Children(1);
firstRow.Style = headerRowStyleforSignal; 

append(rpt,tableforSignal);
add(rpt, mlreportgen.dom.PageBreak);

%% Page Layout Landspace

pageLayoutObj = PDFPageLayout;

pageLayoutObj.PageSize.Orientation = "landscape"; % or portrait
pageLayoutObj.PageSize.Height = "8.5in";
pageLayoutObj.PageSize.Width = "11in";

pageLayoutObj.PageMargins.Top = "0.5in";
pageLayoutObj.PageMargins.Bottom = "0.5in";
pageLayoutObj.PageMargins.Left = "0.5in";
pageLayoutObj.PageMargins.Right = "0.5in";

pageLayoutObj.PageMargins.Header = "0.3in";
pageLayoutObj.PageMargins.Footer = "0.3in";



%% Adding Models to the report

add(rpt,pageLayoutObj);

formalImg1 = FormalImage( ...
    "Image",("C:\Users\alperen.sever\Desktop\SystemComposerApplication\System_Composer_SS\App_Deblocking.png"), ...
    "Caption","App_Deblocking ");
centerFormalImage(formalImg1,rpt);

formalImg2 = FormalImage( ...
    "Image",("C:\Users\alperen.sever\Desktop\SystemComposerApplication\System_Composer_SS\App_Deblocking2.png"), ...
    "Caption","App_Deblocking ");
centerFormalImage(formalImg2,rpt);

formalImg3 = FormalImage( ...
    "Image",("C:\Users\alperen.sever\Desktop\SystemComposerApplication\System_Composer_SS\App_Derating.png"), ...
    "Caption","App_Derating ");
centerFormalImage(formalImg3,rpt);

formalImg4 = FormalImage( ...
    "Image",("C:\Users\alperen.sever\Desktop\SystemComposerApplication\System_Composer_SS\App_deratingPcbTemp.png"), ...
    "Caption","App_DeratingPcbTemp ");
centerFormalImage(formalImg4,rpt);

formalImg5 = FormalImage( ...
    "Image",("C:\Users\alperen.sever\Desktop\SystemComposerApplication\System_Composer_SS\App_Diag.png"), ...
    "Caption","App_Diag ");
centerFormalImage(formalImg5,rpt);

formalImg6 = FormalImage( ...
    "Image",("C:\Users\alperen.sever\Desktop\SystemComposerApplication\System_Composer_SS\App_Diag_part1.png"), ...
    "Caption","App_Diag ");
centerFormalImage(formalImg6,rpt);

formalImg7 = FormalImage( ...
    "Image",("C:\Users\alperen.sever\Desktop\SystemComposerApplication\System_Composer_SS\App_Diag_part2.png"), ...
    "Caption","App_Diag ");
centerFormalImage(formalImg7,rpt);

formalImg8 = FormalImage( ...
    "Image",("C:\Users\alperen.sever\Desktop\SystemComposerApplication\System_Composer_SS\App_DiagHandle.png"), ...
    "Caption","App_DiagHandle");
centerFormalImage(formalImg8,rpt);

formalImg9 = FormalImage( ...
    "Image",("C:\Users\alperen.sever\Desktop\SystemComposerApplication\System_Composer_SS\App_DiagManage.png"), ...
    "Caption","App_DiagManage");
centerFormalImage(formalImg9,rpt);

formalImg10 = FormalImage( ...
    "Image",("C:\Users\alperen.sever\Desktop\SystemComposerApplication\System_Composer_SS\App_StateMachine.png"), ...
    "Caption","State Machine Diagram");
centerFormalImage(formalImg10,rpt);

formalImg11 = FormalImage( ...
    "Image",("C:\Users\alperen.sever\Desktop\SystemComposerApplication\System_Composer_SS\Main.png"), ...
    "Caption","Main Structure ");
centerFormalImage(formalImg11,rpt);


close(rpt);
rptview(rpt);




