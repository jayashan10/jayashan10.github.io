---
title: RAG for Clinical Trials Documents
tags: [Python, LLMs]
style: 
color: 
description: using RAG to implement a Clinical Trials documents assistant
---
# RAG Baseline
The baseline was created using Llama Index as the chucking engine. There are lots of options to explore in chunking. I have used a basic fixed size chunking for now. While creating chunks, it is important to store metadata related to the chunks like, page no, Document name etc. It can be helpful during response generation, as it provides extra context to the LLMs about what the chunk is. [Levels of chunking](https://medium.com/@anuragmishra_27746/five-levels-of-chunking-strategies-in-rag-notes-from-gregs-video-7b735895694d), This blog post explains the different kinds of chunking, and [Greg Karmadt's Video](https://www.youtube.com/watch?v=8OJC21T2SL4) explains the implementation of these techniques. One interesting technique which deserves a try is semantic chunking, where chunks are created based on the semantic relations between the text, instead of random sentence/sections spliting. Next, I used [FIASS](https://ai.meta.com/tools/faiss/) for generating the embeddings for chunks and indexing these vector embeddings. For response generation, I tired to focus on Open-source models as I wanted to avoid privacy concerns in using closed models, as there have been claims that those companies train data on user inputs, and healthcare as an industry is genrally against these practices. I deployed LLama3-8b on [Modal Labs](https://modal.com/). Modal is a serverless platform specifically for AI applications. I used streamlit to create a chatbot interface and used streamlit pills to have some preconfigured prompts related to clinical trial documents. I managed to create sourcing for my answers, by displaying the chunks used for context during the response generation. 

# Features in Future
I would like to focus more on Evaluations for my applications. I have started looking into vendors who might be useful to explore on. Braintrus and Parea are ones I will be deep-diving to. Langsmith is also one, which I feel can be helpful for my usecase. Hamel Hussain has posited that, its best to have an intial evaluation system setup, before implementing any LLM systems. It should be the baseline component while working on LLMs. 

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">I often hear that evals are the most confusing part of creating LLM AI products. It&#39;s a shame b/c IMO, domain-specific evals are the most important part of an AI product!<br><br>I&#39;ve written a detailed blog post with real examples on how to do this (1/3)<a href="https://t.co/AZZ8VZD3vO">https://t.co/AZZ8VZD3vO</a></p>&mdash; Hamel Husain (@HamelHusain) <a href="https://twitter.com/HamelHusain/status/1773765490663735319?ref_src=twsrc%5Etfw">March 29, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

The other feature I would like to focus more on is the report generation. I am an avid twitter user and Jason Liu who is a master at RAG and has developed a library called Instructor which helps in clear formatting of resposes from LLMs. His take on the future of RAG is that there is a lot more extractable economic value in RAG by generating reports than using it for Question and Answer generation. 


<blockquote class="twitter-tweet"><p lang="en" dir="ltr">There is my prediction on where RAG is headed. In this video i talk about <br><br>- Shift from RAG as question-answering systems to report generation tools<br>- Importance of well-designed templates and SOPs in driving business value (selling to people with money)<br>- Room for AI-generated… <a href="https://t.co/A4B0aLAV6I">pic.twitter.com/A4B0aLAV6I</a></p>&mdash; jason liu (@jxnlco) <a href="https://twitter.com/jxnlco/status/1793800023689338921?ref_src=twsrc%5Etfw">May 24, 2024</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

And recently there has been more focus on using BM25 and implementing a hybrid system using keywords search and symantic search. That is one interesting pathway to focus on. And there are also many prompting techniques like COT, DSPy etc. which can be helpful in report generations. 

I would also love to explore how fine-tuning of open models can help me in this application. I think, I can improve the responses generated to be more aligned to healthcare. It could be something like including ICD codes during generation, removing PII, exploring opportunities in synthetic data generation etc..
