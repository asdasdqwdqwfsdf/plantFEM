module DictionaryClass
    use MathClass

    type ::  Page_
        character*200 :: value
        integer :: IntValue
        real(8) :: RealValue
        integer,allocatable :: intlist(:)
        real(8),allocatable :: realist(:)
    end type

    type :: Dictionary_
        type(Page_),allocatable :: Dictionary(:)
    contains
        procedure :: Init => InitializeDictionary
        procedure :: Input => InputDictionary
        procedure :: Get => GetDictionaryValue
        procedure :: GetPageNum => GetPageNumDictionary 
        procedure :: sizeof => sizeofDictionary
        procedure :: content => contentofDictionary
        procedure :: intlist => intlistofDictionary
        procedure :: intvalue => intvalueofDictionary
        procedure :: realvalue => realvalueofDictionary
        procedure :: show => showDictionary

    end type

    type, extends(Page_) :: FileInfo_
        character*200 :: Path
        character*200 :: DirectoryName
        character*200 :: FileName
        integer       :: FileID
    end type


    type :: FileList_
        type(FileInfo_),allocatable:: FileList(:)
    contains
        procedure :: setFilePath
        procedure :: setDirectoryName
        procedure :: setFileName
    end type

contains

! ##############################################
subroutine InitializeDictionary(obj,NumOfPage)
    class(Dictionary_),intent(inout)::obj
    integer,intent(in)      :: NumOfPage
    if(allocated(obj%Dictionary) )then
        deallocate(obj%Dictionary)
    endif

    allocate(obj%Dictionary(NumOfPage) )

end subroutine
! ##############################################


! ##############################################
subroutine InputDictionary(obj,page,content,RealValue,IntValue,Realist,Intlist)
    class(Dictionary_),intent(inout)::obj
    integer,intent(in)      :: page
    character(*),optional,intent(in)           :: Content
    integer,optional,intent(in) :: IntValue,Intlist(:)
    real(8),optional,intent(in) :: RealValue,Realist(:)
    
    if(page > size(obj%Dictionary) )then
        print *, "Error :: InputDictionary >> Num of Page is overflowed"
        stop
    endif
    if(present(RealValue)  )then
        obj%Dictionary(page)%RealValue = RealValue
        return
    endif
    if(present(Realist)  )then
        if(allocated(obj%Dictionary(page)%Realist) )then
            deallocate(obj%Dictionary(page)%Realist)
        endif
        allocate(obj%Dictionary(page)%Realist(size(Realist,1) ) )
        obj%Dictionary(page)%Realist(:) = Realist(:)
        return
    endif
    if(present(IntValue)  )then
        obj%Dictionary(page)%intValue = intValue
        return
    endif
    if(present(intlist)  )then
        if(allocated(obj%Dictionary(page)%intlist) )then
            deallocate(obj%Dictionary(page)%intlist)
        endif
        allocate(obj%Dictionary(page)%intlist(size(intlist,1) ) )
        obj%Dictionary(page)%intlist(:) = intlist(:)
        return
    endif

    if(present(content) )then
        obj%Dictionary(page)%Value = content 
    endif
end subroutine
! ##############################################



! ##############################################
function intlistofDictionary(obj,page,ind) result(n)
    class(Dictionary_),intent(in) :: obj
    integer,intent(in) :: page,ind
    integer :: n

    n=obj%Dictionary(page)%intlist(ind)

end function
! ##############################################

! ##############################################
function intvalueofDictionary(obj,page) result(n)
    class(Dictionary_),intent(in) :: obj
    integer,intent(in) :: page
    integer :: n

    n=obj%Dictionary(page)%intvalue

end function
! ##############################################



! ##############################################
function realvalueofDictionary(obj,page) result(n)
    class(Dictionary_),intent(in) :: obj
    integer,intent(in) :: page
    real(8) :: n

    n=obj%Dictionary(page)%realvalue

end function
! ##############################################



! ##############################################
function GetDictionaryValue(obj,page) result(content)
    class(Dictionary_),intent(in)::obj
    integer,intent(in)      :: page
    character*200 :: content

    content = obj%Dictionary(page)%Value

end function
! ##############################################

! ##############################################
subroutine setFilePath(obj,FilePath,FileID) 
    class(FileList_),intent(inout)::obj
    integer,intent(in) :: FileID
    character*200,intent(in) :: FilePath

    obj%FileList(FileID)%Path = FilePath

end subroutine
! ##############################################

! ##############################################
subroutine setDirectoryName(obj,DirectoryName,FileID) 
    class(FileList_),intent(inout)::obj
    integer,intent(in) :: FileID
    character*200,intent(in) :: DirectoryName

    obj%FileList(FileID)%DirectoryName = DirectoryName

end subroutine
! ##############################################


! ##############################################
subroutine setFileName(obj,FileName,FileID) 
    class(FileList_),intent(inout)::obj
    integer,intent(in) :: FileID
    character*200,intent(in) :: FileName

    obj%FileList(FileID)%FileName = FileName

end subroutine
! ##############################################


! ##############################################
subroutine showDictionary(obj,From,to)
    class(Dictionary_)::obj
    integer,optional,intent(in)::From,to
    integer :: i,n,startp,endp

    n=size(obj%Dictionary,1)

    startp=input(default=1,option=From)
    endp  =input(default=n,option=to)
    do i=startp,endp
        print *, "Page : ",i,"Content : ",trim(obj%Dictionary(i)%Value )
    enddo

end subroutine
! ##############################################


! ##############################################
function sizeofDictionary(obj) result(n)
    class(Dictionary_),intent(in) :: obj
    integer :: n

    n = size(obj%Dictionary)

end function
! ##############################################


! ##############################################
function contentofDictionary(obj,id) result(content)
    class(Dictionary_),intent(in) :: obj
    integer,intent(in) :: id
    character*200 :: content
 
    content = obj%Dictionary(id)%value

end function
! ##############################################



! ##############################################
function GetPageNumDictionary(obj,Content) result(page)
    class(Dictionary_),intent(in)::obj
    character(*),intent(in)::Content
    integer :: page
    integer :: i,n

    n=size(obj%Dictionary,1)
    page=-1
    do i=1,n
        if(trim(Content)==trim(obj%Dictionary(i)%value) )then
            page=i
            return
        endif
    enddo
    if(page==-1)then
        print *, "ERROR ::",trim(Content)," is a word to be found only in the dictionary of fools."
    endif


end function
! ##############################################


end module