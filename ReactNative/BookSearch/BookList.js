/**
 * Created by nicholasjudd on 19/04/2016.
 */
'use strict';

var React = require('react-native');
var BookDetail = require('./BookDetail');
var {
    Image,
    StyleSheet,
    Text,
    TextInput,
    View,
    Picker,
    Component,
    ListView,
    RecyclerViewBackedScrollView,
    TouchableHighlight,
    ActivityIndicatorIOS
} = React;


var styles = StyleSheet.create({
    container: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
        padding: 10
    },
    separator: {
        height: 1,
        backgroundColor: '#dddddd'
    },
    thumbnail: {
        width: 53,
        height: 81,
        marginRight: 10
    },
    rightContainer: {
        flex: 1
    },
    title: {
        fontSize: 20,
        marginBottom: 8
    },
    author: {
        color: '#656565'
    },
    listView: {
        flex: 1,
        backgroundColor: '#F5FCFF'
    },
    BookListContainer: {
        flex: 1,
        paddingTop: 64
    },
    topBar: {
        flex: 0.3
    },
    mainScreen: {
        flex: 0.7
    },
    loading: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center'
    },
    searchContainer: {
        flex: .2,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center'
    },
    pickerContainer: {
        flex: .6,
        flexDirection: 'row',

        backgroundColor: 'red'
    },
    searchBox: {
        flex: 0.8,
        flexDirection: 'row',
        borderColor: 'gray',
        borderWidth: 1,
    },
    searchButton: {
        flex: 0.2,
    },
    subjectPicker: {
        flex: 1,
        height: 50,
        flexDirection: 'column'
    },

});

class BookList extends Component {

    constructor(props) {
        super(props);
        this._getSubjectData = this._getSubjectData.bind(this);
        this._onPressButton = this._onPressButton.bind(this);
        this.state = {
            isLoading: true,
            dataSource: new ListView.DataSource({
                rowHasChanged: (row1, row2) => row1 !== row2
            }),
            searchBy: "Title",
            searchTerm: "",
            author: "",
            subject: "fiction",
            SUBJECT_REQUEST_URL: 'https://www.googleapis.com/books/v1/volumes?q=subject:',
            AUTHOR_REQUEST_URL: 'https://www.googleapis.com/books/v1/volumes?q=inauthor',
            TITLE_REQUEST_URL: 'https://www.googleapis.com/books/v1/volumes?q=intitle:'
        }
    }

    componentDidMount() {
        this.fetchDataSubject();
    }

    fetchDataSubject() {
        console.log(this.state.subject);
        fetch(this.state.SUBJECT_REQUEST_URL + this.state.subject)
            .then((response) => response.json())
            .then((responseData) => {
                console.log(responseData);
                this.setState({
                    dataSource: this.state.dataSource.cloneWithRows(responseData.items),
                    isLoading: false
                });
            })
            .done();
    }

    fetchDataTitle() {
        fetch(this.state.TITLE_REQUEST_URL + this.state.searchTerm)
            .then((response) => response.json())
            .then((responseData) => {
                console.log(responseData);
                this.setState({
                    dataSource: this.state.dataSource.cloneWithRows(responseData.items),
                    isLoading: false
                });
            })
            .done();
    }

    fetchDataAuthor() {
        fetch(this.state.AUTHOR_REQUEST_URL + this.state.searchTerm)
            .then((response) => response.json())
            .then((responseData) => {
                console.log(responseData);
                this.setState({
                    dataSource: this.state.dataSource.cloneWithRows(responseData.items),
                    isLoading: false
                });
            })
            .done();
    }

    renderBook(book) {
        return (
            <TouchableHighlight onPress={() => this.showBookDetail(book)} underlayColor='#dddddd'>
                <View>
                    <View style={styles.container}>
                        <Image
                            source={book.volumeInfo.imageLinks != undefined ? {uri: book.volumeInfo.imageLinks.thumbnail}: require('./content.jpeg')}

                            style={styles.thumbnail}/>
                        <View style={styles.rightContainer}>
                            <Text style={styles.title}>{book.volumeInfo.title}</Text>
                            <Text style={styles.author}>{book.volumeInfo.authors}</Text>
                        </View>
                    </View>
                    <View style={styles.separator}/>
                </View>
            </TouchableHighlight>
        );
    }

    showBookDetail(book) {
        this.props.navigator.push({
            title: book.volumeInfo.title,
            component: BookDetail,
            passProps: {book}
        });
    }

    _getSubjectData(sub) {
        this.setState({subject: sub});
        this.fetchDataSubject();
    }

    _onPressButton() {
        console.log(this.state.searchBy);
        if (this.state.searchBy = "Title") {
            this.fetchDataTitle();
        } else if (this.state.searchBy = "Author") {
            this.fetchDataAuthor()
        }
    }

    render() {
        if (this.state.isLoading) {
            return this.renderLoadingView();
        }
        return (
            <View style={styles.BookListContainer}>
                <View style={styles.topBar}>
                    <View style={styles.searchContainer}>
                        <TextInput
                            style={styles.searchBox}
                            onChangeText={(searchTerm) => this.setState({searchTerm})}
                            value={this.state.searchTerm}
                        />
                        <TouchableHighlight onPress={this._onPressButton}
                                            style={styles.searchButton}>
                            <Text style={styles.buttonText}>Search</Text>
                        </TouchableHighlight>
                    </View>
                    <View style={styles.pickerContainer}>

                        <Picker
                            selectedValue={this.state.subject}
                            onValueChange={(sub) => this._getSubjectData(sub)}
                            style={styles.subjectPicker}>
                            <Picker.Item label="fiction" value="fiction"/>
                            <Picker.Item label="nonfiction" value="nonfiction"/>
                        </Picker>
                        <Picker
                            selectedValue={this.state.searchBy}
                            onValueChange={(sB) => this.setState({searchBy: sB})}
                            style={styles.subjectPicker}>
                            <Picker.Item label="Title" value="Title"/>
                            <Picker.Item label="Author" value="Author"/>
                        </Picker>
                    </View>
                </View>
                <View style={styles.mainScreen}>
                    <ListView
                        dataSource={this.state.dataSource}
                        renderRow={this.renderBook.bind(this)}
                        renderScrollComponent={props => <RecyclerViewBackedScrollView {...props} />}
                        style={styles.listView}
                    />
                </View>
            </View>
        )
            ;
    }

    renderLoadingView() {
        return (
            <View style={styles.loading}>
                <ActivityIndicatorIOS
                    size='large'/>
                <Text>
                    Loading books...
                </Text>
            </View>
        );
    }
}

module.exports = BookList;