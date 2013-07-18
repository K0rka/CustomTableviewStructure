//
//  CustomTableDataStructure.h
//  looky
//
//  Created by Korovkina Katerina on 11.02.13.
//

#import <Foundation/Foundation.h>

#define EMPTY_SECTION_NAME @"empty name"


/**
	Класс, описывающий структуру таблицы (набор секций и соответствующих им ячеек)
 */
@interface CustomTableDataStructure : NSObject <NSCopying>


- (id) initWithSectionsArray:(NSArray *)sectionStructure;

/**
	Метод добавления новой секции в текущую структуру. При этом считается, что название секции будет использоваться для вывода
    Если секция с таким именем уже есть, то данные в ней заменятся на новые. Старые данные при этом будут утеряны. 
	@param sectionName название добавляемой секции
	@param rowsNames массив идентификаторов ячеек в добавляемой секции
 */
- (void) addSection:(NSString *)sectionName withRows:(NSArray *)rowsNames;


/**
	Метод добавления новой секции в текущую структуру
    Если секция с таким именем уже есть, то данные в ней заменятся на новые. Старые данные при этом будут утеряны.
	@param sectionName название добавляемой секции
	@param rowsNames массив идентификаторов ячеек в добавляемой секции
	@param needSectiontitle будет ли использоваться название этой секции для вывода
 */
- (void) addSection:(NSString *)sectionName withRows:(NSArray *)rowsNames needSectiontitle:(BOOL)needSectiontitle;


/**
	Метод добавления ячейки с идентификатором rowId в секцию sectionName. Если такой секции нет, значит она создастся. 
	@param rowId идентификатор ячейки, который необходимо добавить
	@param sectionName название секции, к которой добавляется ячейка
	@returns новую структуру таблицы с добавленной ячейкой
 */
- (void) addRow:(id)rowId toSection:(NSString *)sectionName;


/**
	Метод для получения массива идентификаторов ячеек в секции с названием sectionName
    @param sectionName название секции, ячейки которой необходимо получить
	@returns массив идентификаторов ячеек секции
 */
- (NSArray *) rowsInSection:(NSString *)sectionName;


/**
	Удаление ячейки с соответствующим идентификатором. Если эта ячейка была последней в секции, то удаляется вся секция. Если ячейка с таким идентификатором не найдена, то ничего не происходит.
	@param rowId идентификатор ячейки, которую необходимо удалить
 */
- (void) deleteRow:(id)rowId;


/**
	Удаление секции со всеми содержазимися в ней ячейками. Если секции с таким названием нет, то никаких изменений не происходит. 
	@param sectionName название секции, которую необходимо удалить
 */
- (void) deleteSection:(NSString *)sectionName;


/**
    Метод удаления секции по ее индексу
    @param sectionIndex индекс секции, которую надо удалить
 */
- (void) deleteSectionAtIndex:(NSUInteger)sectionIndex;


/**
	Метод получения количества секций в структуре данных
	@returns количество секций
 */
- (NSUInteger) sectionsCount;


/**
    Метод получения количества ячеек в заданной секции
	@param sectionName название секции
	@returns количество ячеек в секции с названием sectionName
 */
- (NSUInteger) numberForRowsInSection:(NSString *)sectionName;


/**
	Метод получения количества ячеек в секции
	@param sectionIndex индекс секции, количество ячеек для которой надо получить
	@returns количество ячеек в этой секции
 */
- (NSUInteger)numberForRowsInSectionAtIndex:(NSUInteger)sectionIndex;


/**
	Метод получения названия секции по соответствующему индексу
	@param sectionIndex индекс секции
	@returns название секции
 */
- (NSString *) titleForSectionAtIndex:(NSUInteger)sectionIndex;


/**
	Метод определения индекса секции
	@param sectionName название секции, индекс которой надо определить
	@returns индекс секции
 */
- (NSUInteger) indexForSection:(NSString *)sectionName;


/**
	Возвращает объект (идентификатор яечйки) хранящийся по indexPath
	@param indexPath адрес запрашиваемой ячейки
	@returns идентификатор ячейки
 */
- (id) objectAtIndexPath:(NSIndexPath *)indexPath;


/**
	Метод для получения NSIndexPath ячейки
	@param rowId идентификатор ячейки, NSIndexPath которой надо получить
	@returns NSIndexPath к заданной ячейке
 */
- (NSIndexPath *) indexPathForRow:(id)rowId;


/**
    Метод вставки секции с определенным набором ячеек по соответствующему индексу
	@param sectionName название вставляемой секции
	@param rowsArray массив содержащихся в секции идентификаторов ячеек
	@param index индекс, на который надо вставить секцию
 */
- (void) insertSection:(NSString *)sectionName withRows:(NSArray *)rowsArray needSectiontitle:(BOOL)needSectiontitle atIndex:(NSInteger)index;

@end
