module Treat
  module Extractors
    module NamedEntity
      class Stanford
        # Require the Ruby-Java bridge.
        silence_warnings do 
          require 'rjb'
          Rjb::load(nil, ['-Xms256M', '-Xmx1024M'])
          Rjb::add_jar('/ruby/treat/bin/treat/treat.jar')
          Rjb::add_jar('/ruby/treat/bin/stanford/xom.jar')
          Rjb::add_jar('/ruby/treat/bin/stanford/joda-time.jar')
          Rjb::add_jar('/ruby/treat/bin/stanford/stanford-corenlp.jar')
          StanfordCoreNLP = Rjb::import('edu.stanford.nlp.pipeline.StanfordCoreNLP')
          Annotation = Rjb::import('edu.stanford.nlp.pipeline.Annotation')
          NamedEntityTagAnnotation = Rjb::import('edu.stanford.nlp.ling.CoreAnnotations$NamedEntityTagAnnotation')
          Properties = Rjb::import('java.util.Properties')
        end
        @@classifier = nil
        def self.named_entity(entity, options = {})
          properties = Properties.new
          properties.set_property('annotators', 'tokenize, ssplit, pos, lemma, ner')
          properties.set_property('pos.model', '/ruby/treat/bin/stanford/taggers/english-left3words-distsim.tagger')
          properties.set_property('ner.model.3class', '/ruby/treat/bin/stanford/classifiers/all.3class.distsim.crf.ser.gz')
          properties.set_property('ner.model.7class', '/ruby/treat/bin/stanford/classifiers/muc.7class.distsim.crf.ser.gz')
          properties.set_property('ner.model.MISCclass', '/ruby/treat/bin/stanford/classifiers/conll.4class.distsim.crf.ser.gz')
          properties.set_property('parser.model', '/ruby/treat/bin/stanford-parser/grammar/englishPCFG.ser.gz')
          silence_stream(STDOUT) do
            pipeline = StanfordCoreNLP.new(properties)
          end
          stanford_entity = Annotation.new(entity.to_s)
          pipeline.annotate(stanford_entity)
          puts stanford_entity.java_methods
          puts stanford_entity.get_string(NamedEntityTagAnnotation)
        end
      end
    end
  end
end


=begin



CRFBiasedClassifier = Rjb::import('edu.stanford.nlp.ie.crf.CRFBiasedClassifier')
Properties = Rjb::import('java.util.Properties')
List = ::Rjb::import('java.util.ArrayList')
Word = ::Rjb::import('edu.stanford.nlp.ling.Word')
CoreAnnotations = ::Rjb::import('edu.stanford.nlp.ling.CoreAnnotations')
if @@classifier == nil
  properties = Properties.new
  options.each_pair do |option,value|
    #properties.set_property('trainFile', )... Set the options.
  end
  @@classifier = CRFBiasedClassifier.new(properties)
  @@classifier.load_classifier("/ruby/treat/bin/stanford_ner/classifiers/conll.4class.distsim.crf.ser.gz")
end
w = Word.new('Obama')
#puts @@classifier.java_methods
puts CoreAnnotations.public_methods.inspect
puts @@classifier.classify(w).get()


/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package corenlp;
import edu.stanford.nlp.ling.CoreAnnotations.CollapsedCCProcessedDependenciesAnnotation;
import edu.stanford.nlp.ling.CoreAnnotations.CorefGraphAnnotation;
import edu.stanford.nlp.ling.CoreAnnotations.NamedEntityTagAnnotation;
import edu.stanford.nlp.ling.CoreAnnotations.PartOfSpeechAnnotation;
import edu.stanford.nlp.ling.CoreAnnotations.SentencesAnnotation;
import edu.stanford.nlp.ling.CoreAnnotations.TextAnnotation;
import edu.stanford.nlp.ling.CoreAnnotations.TokensAnnotation;
import edu.stanford.nlp.ling.CoreAnnotations.TreeAnnotation;
import edu.stanford.nlp.ling.CoreLabel;
import edu.stanford.nlp.pipeline.*;
import edu.stanford.nlp.trees.Tree;
import edu.stanford.nlp.trees.semgraph.SemanticGraph;
import edu.stanford.nlp.util.CoreMap;
import edu.stanford.nlp.util.IntTuple;
import edu.stanford.nlp.util.Pair;
import edu.stanford.nlp.util.Timing;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import java.util.Properties;
/**
 *
 * @author Karthi
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException, ClassNotFoundException {
//        // TODO code application liogic here
//        System.out.println(System.getProperty("sun.arch.data.model"));
////        String str="-cp stanford-corenlp-2010-11-12.jar:stanford-corenlp-models-2010-11-06.jar:xom-1.2.6.jar:jgrapht-0.7.3.jar -Xms3g edu.stanford.nlp.pipeline.StanfordCoreNLP -file <input.txt>";
////        args=str.split(" ");
////        StanfordCoreNLP.main(args);
//        Timing tim = new Timing();
//        Properties props = null;
//        props.setProperty("annotators", "ssplit, ner, parse, dcoref");
//
//        StanfordCoreNLP pipeline = new StanfordCoreNLP(props);
//    props = pipeline.getProperties();
//    long setupTime = tim.report();
//    String fileName = "input.txt";
//      ArrayList<File> files=null;
//      files.add(new File(filename));
//      pipeline.processFiles(pipeline, files, props);
//
//


        // creates a StanfordCoreNLP object, with POS tagging, lemmatization, NER, parsing, and coreference resolution
    Properties props = new Properties();
    FileInputStream in = new FileInputStream("Main.properties");

    props.load(in);
    in.close();
    StanfordCoreNLP pipeline = new StanfordCoreNLP(props);

    // read some text in the text variable
    String text = "The doctor can consult with other doctors about this patient. If that is the case, the name of the doctor and the names of the consultants have to be maintained. Otherwise, only the name of the doctor is kept. "; // Add your text here!

    // create an empty Annotation just with the given text
    Annotation document = new Annotation(text);

    // run all Annotators on this text
    pipeline.annotate(document);
    System.out.println(document);
    
    // these are all the sentences in this document
    // a CoreMap is essentially a Map that uses class objects as keys and has values with custom types
    List<CoreMap> sentences = (List<CoreMap>) document.get(SentencesAnnotation.class);
    System.out.println(sentences);
    for(CoreMap sentence: sentences) {
      // traversing the words in the current sentence
      // a CoreLabel is a CoreMap with additional token-specific methods
      for (CoreLabel token: sentence.get(TokensAnnotation.class)) {
        // this is the text of the token
        String word = token.get(TextAnnotation.class);
        // this is the POS tag of the token
        String pos = token.get(PartOfSpeechAnnotation.class);
        // this is the NER label of the token
        String ne = token.get(NamedEntityTagAnnotation.class);
      }

      // this is the parse tree of the current sentence
      Tree tree = sentence.get(TreeAnnotation.class);
System.out.println(tree);
      // this is the Stanford dependency graph of the current sentence
      SemanticGraph dependencies = sentence.get(CollapsedCCProcessedDependenciesAnnotation.class);
      System.out.println(dependencies);
    }

    // this is the coreference link graph
    // each link stores an arc in the graph; the first element in the Pair is the source, the second is the target
    // each node is stored as <sentence id, token id>. Both offsets start at 1!
    List<Pair<IntTuple, IntTuple>> graph = document.get(CorefGraphAnnotation.class);
    System.out.println(graph);

    }

}
=end