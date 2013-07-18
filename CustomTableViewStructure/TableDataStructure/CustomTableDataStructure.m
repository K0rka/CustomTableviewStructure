//
//  CustomTableDataStructure.m
//  looky
//
//  Created by Korovkina Katerina on 11.02.13.
//

#import "CustomTableDataStructure.h"
#import "NSObject+DeepCopy.h"

@interface CustomTableDataStructure ()  {
    
    NSMutableDictionary *_structureDictionary;
    NSMutableArray *_sectionsNameArray;
}

@property (nonatomic) NSMutableDictionary *structureDictionary;
@property (nonatomic) NSMutableArray *sectionsNameArray;


@end

@implementation CustomTableDataStructure
@synthesize structureDictionary = _structureDictionary;
@synthesize sectionsNameArray = _sectionsNameArray;


//===============================================================================
- (id) copyWithZone:(NSZone *)zone {
    CustomTableDataStructure *newObj = [[[self class] allocWithZone:zone] init];
    
    [newObj setStructureDictionary:[self.structureDictionary mutableDeepCopy]];
    [newObj setSectionsNameArray:[self.sectionsNameArray mutableDeepCopy]];
    
    return newObj;
}



//===============================================================================
- (id) init {
    self = [super init];
    if (self) {
        
        _structureDictionary = [NSMutableDictionary dictionary];
        _sectionsNameArray = [NSMutableArray array];
        
    }
    return self;
}



//==============================================================================
- (id) initWithSectionsArray:(NSArray *)sectionStructure {
    
    //Да, именно self
    self = [self init];
    if (self) {
       
        //
        for (id nextObj in sectionStructure) {
            //if it's dictionary its values will be used as rows ids
            if ([nextObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = nextObj;
                
                for (id nextKey in dic) {
                    [self addSection:nextKey withRows:[dic objectForKey:nextKey]];
                }
            }
            //for all other objects it'll be only section id
            else {
                [self.sectionsNameArray addObject:nextObj];
                [self.structureDictionary addEntriesFromDictionary:@{nextObj : [NSMutableArray array]}];
            }
        }
        
    }
    
    return self;
}

//===============================================================================
- (void)addSection:(NSString *)sectionName withRows:(NSArray *)rowsNames {
    [self addSection:sectionName withRows:rowsNames needSectiontitle:YES];
}


//===============================================================================
/**
    Метод добавления новой секции в текущую структуру
    @param sectionName название добавляемой секции
    @param rowsNames массив идентификаторов ячеек в добавляемой секции
 */
- (void) addSection:(NSString *)sectionName withRows:(NSArray *)rowsNames needSectiontitle:(BOOL)needSectiontitle {
    
    if (!sectionName || !rowsNames) {
        NSLog(@" %@ : parameters can't be nil", NSStringFromSelector(_cmd));
        return;
    }

    //Массивы ячеек для секций всегда изменяемые!
    [self.structureDictionary addEntriesFromDictionary:@{sectionName : [NSMutableArray arrayWithArray:rowsNames]}];
    [self.sectionsNameArray addObject:sectionName];
}


/**
    Метод добавления ячейки с идентификатором rowId в секцию sectionName. Если такой секции нет, значит она создастся
    @param rowId идентификатор ячейки, который необходимо добавить
    @param sectionName название секции, к которой добавляется ячейка
    @returns новую структуру таблицы с добавленной ячейкой
 */
- (void) addRow:(id)rowId toSection:(NSString *)sectionName {
    
    if (!sectionName || !rowId) {
        NSLog(@" %@ : parameters can't be nil", NSStringFromSelector(_cmd));
        return;
    }
    
    NSMutableArray *valueArray = [self.structureDictionary valueForKey:sectionName];
    NSUInteger index = [valueArray indexOfObject:rowId];
    
    //Если такой элемент не найден, то добавляем его в конец
    if (index == NSNotFound) {
        [valueArray addObject:rowId];
    }
    
}


//===============================================================================
/**
    Метод для получения массива идентификаторов ячеек в секции с названием sectionName
    @param sectionName название секции, ячейки которой необходимо получить
    @returns массив идентификаторов ячеек секции
 */
- (NSArray *) rowsInSection:(NSString *)sectionName {
    return [self.structureDictionary valueForKey:sectionName];
}


//===============================================================================
/**
    Удаление ячейки с соответствующим идентификатором. Если эта ячейка была последней в секции, то удаляется вся секция. 
    Если ячейка с таким идентификатором не найдена, то ничего не происходит.
    @param rowId идентификатор ячейки, которую необходимо удалить
 */
- (void) deleteRow:(id)rowId {
    
    if (!rowId) {
        NSLog(@" %@ : parameters can't be nil", NSStringFromSelector(_cmd));
        return;
    }
    
    __block id section = nil;
    //Находим секцию, в которой находится искомая ячейка
    [self.structureDictionary enumerateKeysAndObjectsUsingBlock:^(id key, NSMutableArray *sectionRows, BOOL *stop) {
        
        [sectionRows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqual:rowId]) {
                section = key;
                *stop = YES;
            }
        }];
    }];
    
    //Если нашли такую секцию
    if (section) {
        //Получаем массив ячеек в найденной секции. 
        NSMutableArray *sectionRows = [self.structureDictionary valueForKey:section];
        
        //Удаляем объект ячейки из этой секции
        [sectionRows removeObject:rowId];
        
        //Если не осталось ни одного элемента в этой секции, то удаляем и всю секцию тоже
        if (!sectionRows.count) {
            [self deleteSection:section];
            
        }
    }
}



/**
    Удаление секции со всеми содержазимися в ней ячейками. Если секции с таким названием нет, то никаких изменений не происходит.
    @param sectionName название секции, которую необходимо удалить
 */
- (void) deleteSection:(NSString *)sectionName {
    
    if (!sectionName) {
        NSLog(@" %@ : parameters can't be nil", NSStringFromSelector(_cmd));
        return;
    }
    
    [self.structureDictionary removeObjectForKey:sectionName];
    
    [self.sectionsNameArray removeObject:sectionName];
}


//===============================================================================
- (void) deleteSectionAtIndex:(NSUInteger)sectionIndex {
    [self deleteSection:[_sectionsNameArray objectAtIndex:sectionIndex]];
}

//===============================================================================
- (NSUInteger) sectionsCount {
    return [self.structureDictionary count];
}

//===============================================================================
- (NSUInteger) numberForRowsInSection:(NSString *)sectionName {
    if (!sectionName) {
//        DDLogVerbose(@" %@ : parameters can't be nil", NSStringFromSelector(_cmd));
        return NSNotFound;
    }
    return [[self.structureDictionary valueForKey:sectionName] count];
}

//===============================================================================
- (NSUInteger)numberForRowsInSectionAtIndex:(NSUInteger)sectionIndex {
    return [self numberForRowsInSection:[_sectionsNameArray objectAtIndex:sectionIndex]];
}

//===============================================================================
- (NSString *) titleForSectionAtIndex:(NSUInteger)sectionIndex {
    NSString *title = [self.sectionsNameArray objectAtIndex:sectionIndex];
    NSRange range = [title rangeOfString:EMPTY_SECTION_NAME];
    return range.length ? nil : title;
}



//===============================================================================
- (NSUInteger) indexForSection:(NSString *)sectionName {
    return [self.sectionsNameArray indexOfObject:sectionName];
}

//===============================================================================
- (id) objectAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        NSLog(@" %@ : parameters can't be nil", NSStringFromSelector(_cmd));
        return nil;
    }
    NSArray *rowsArray = [self rowsInSection:[self.sectionsNameArray objectAtIndex:indexPath.section]];
    return [rowsArray objectAtIndex:indexPath.row];
}


//===============================================================================
//Получений пути к заданной ячейке
- (NSIndexPath *)indexPathForRow:(id)rowId {
    
    if (!rowId) {
        NSLog(@" %@ : parameters can't be nil", NSStringFromSelector(_cmd));
        return nil;
    }
    
    
    __block id section = nil;
    __block NSInteger index = 0;
    //Находим секцию, в которой находится искомая ячейка
    [self.structureDictionary enumerateKeysAndObjectsUsingBlock:^(id key, NSMutableArray *sectionRows, BOOL *stop) {
        
        [sectionRows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqual:rowId]) {
                //сохраняем индекс этой ячейки в массиве и ключ секции
                index = idx;
                section = key;
                *stop = YES;
            }
        }];
    }];
    
    //НАходим индекс секциии по ее ключу
    NSInteger sectionIndex = [self.sectionsNameArray indexOfObject:section];
    
    if (sectionIndex != NSNotFound) {
        return [NSIndexPath indexPathForRow:index inSection:sectionIndex];
    }
    else {
        return nil;
    }
    
}



//===============================================================================
- (void) insertSection:(NSString *)sectionName withRows:(NSArray *)rowsArray needSectiontitle:(BOOL)needSectiontitle atIndex:(NSInteger)index {
    
    if (!sectionName || !rowsArray) {
        NSLog(@" %@ : parameters can't be nil", NSStringFromSelector(_cmd));
        return;
    }
    
    //Если есть запись с такой секций, то будет производиться не вставка, а замена: удаляем предыдущие значения, вставлляем новые
    if ([self.structureDictionary valueForKey:sectionName]) {
        
        [self.sectionsNameArray removeObject:sectionName];

    }
    
    [self.structureDictionary addEntriesFromDictionary:@{sectionName : rowsArray}];
    [self.sectionsNameArray insertObject:sectionName atIndex:index];
}



@end
