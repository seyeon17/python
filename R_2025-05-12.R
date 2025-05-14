## 6.4.3.3. str_glue_data() 함수
# Example: str_glue
library(tidyverse)

name <- "Kim"
str_glue("Hello, {name}!
         welcome to team")

name <- c("Kim", NA, "Park")
str_glue("Hi, {name}!")  # 결측값이 그대로 반영됨!

# 만약 결측값에는 Friends라고 출력하고 싶으면?
str_glue("Hi, {name}!", .na = "Friends")

# 열 만들고 싶어.
info <- tibble(name = c("Kim", "Lee", "Park"))
info %>% mutate(greeting = str_glue("Hi, {name}!"))

# Example: str_glue_data()
info <- tibble(name = c("Kim", "Lee", "Park"),
               age = c(25, 30, 42),
               city = c("Seoul", "Jeonbuk", "Gwangju"))


str_glue_data(info, "{name} is {age} years old and lives in {city}." )



info2 <- tibble(name = c("Kim", NA, "Park"),
               age = c(25, 30, NA),
               city = c("Seoul", "Jeonbuk", "Gwangju"))

str_glue_data(info2, "{name} lives in {city}.", .na = "Unknown")

info %>% 
  mutate(message = str_glue_data(info,
                                 "{name} ({age} years old) lives in city"))


## 6.4.3.4. str_flatten() 함수
str_flatten(c("x", "y", "z"))  #이 세개가 하나의 문자열로 바뀜
str_flatten(c("x", "y", "z"), collapse = ", ") 
 # 마지막에 있는 애는 and로 잇고 싶음
str_flatten(c("x", "y", "z"), collapse = ", ", last = " and ") 

mytbl <- tibble(name = c("Carmen", "Carmen", "Marvin", "Terence", "Terence", "Terence"),
                fruit = c("banana", "apple", "nectarine", "cantaloupe", "papaya", "madarine"))
mytbl %>% 
  group_by(name) %>% 
  summarise(fruits = str_flatten(fruit, ", "))

## 6.4.4. 정규 표현식을 이용한 패턴 매칭
## 6.4.4.1. 정규 표현식

# 기초매칭
x <- c("apple", "banana", "pear")
str_view(x, "a")  # a를 찾아서 매칭시켜줌
str_view(x, ".a.")  # a 앞뒤 문자 알파벳 하나씩 포함 매칭

# 앵커(anchor) - 문자열 내 특정 위치(시작 또는 끝) 지정
str_view(x, "^a")             # a로 시작해야 함!
str_view(x, "a$")             # a로 끝나야 함!
str_view(c("abc", ""), "^$")  # 빈 문자열

# 반복
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
  # ? : ? 바로앞의 표현식이 0번 또는 1번 일치
str_view(x, "CC?")  # 여기서 ? 앞의 표현식은 C임. CC 아님. 앞의 C는 고정이야
                    # C 또는 CC를 찾는 것.
                    # 만약에 AB?면 A 또는 AB!

  # + : + 앞의 표현식이 1번 이상 일치 
str_view(x, "CC+")  # cc, ccc, cccc , ...

  # * : 0번 이상 일치
str_view(x, "CC*")  # c,cc, ccc


   ### AB+ <- A, AB, ABB, ABBB, ...
   ### (AB)+ <-  A, AB, ABA, ABAB, ...

  # "C"가 정확히 두 번 반복 -> CC
str_view(x, "c{2}")

  # "C"가 2번 이상 반복 -> CC, CCC, CCCC, ...
str_view(x, "c{2,}")

  # "C"가 2번 이상 3번 이하 반복 -> CC, CCC
str_view(x, "c{2,3}")

x <- c("color", "colour")
str_view(x, "colou?r")

# 그룹화
str <-  c("gray", "grey")
str_view(x, "gr(a|e)y")  # a 또는 e 그룹화

x <- c("summarise", "summarize")
str_view(x, "summari(z|s)e")


## escape 문자
writeLines("ab")
str_view("a\\b", "\\\\")  # \ = 역슬러시

str_view(c("abc", "a.c", "def"), "a\\.c")

## character class
names <- c("Hadley", "Mine", "Garrett")
str_view_all(names, "[aeiou]")   # 모음 매칭
str_view_all(names, "[^aeiou]")  # 자음 매칭
str_view_all(names, "[^aeiou]+") # 자음이 1개 이상인 부분과 묶여서 매칭

text <- "The total cost is 29 dollars\nand 99 cents."
writeLines(text)
str_view(text, "\\d") # 숫자와 매칭
str_view(text, "\\s") # 여백 문자와 매칭



## 6.4.4.2. str_detect() 함수
x <- c("apple", "banana", "pear")
str_detect(x, "e") # e 포함하나요?

# "t"로 시작하는 단어의 개수
words
str_detect(words, "^t") # t로 시작하는지의 여부
sum(str_detect(words, "^t")) # t로 시작하는지의 여부

# "t"로 시작하는 단어 추출
words[str_detect(words, "^t")]
str_subset(words, "^t")

# 모음으로 끝나는 단어의 비율
# 모음으로 끝나는 단어의 개수 / 전체 단어 개수
# sum() /  length() = mean()
str_detect(words, "[aeiou]$")
str_detect(words, "[aeiou]$") %>% mean


# "x"로 끝나는 이름 추출, 필터링 
library(babynames)
babynames %>% filter(str_detect(name, "x$"))

# 연도별 "x"로 끝나는 고유한 이름의 비율
babynames %>% 
  group_by(year) %>% 
  summarise(prop_x = mean(str_detect(name, "x$")
                          

x <- c("apple", "banana", "pear")
str_count(x, "p")

babynames %>% 
  count(name) %>% 
  mutate(vowels = str_count(name, "[AEIOUaeiou]"),
         consonants = str_count(name, "[^AEIOUaeiou]"))








